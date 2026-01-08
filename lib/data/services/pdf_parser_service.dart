import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/analysis_result.dart';
import '../models/transfer_info.dart';

/// Maximum number of pages allowed in PDF to prevent PDF bomb attacks
const int _maxPdfPages = 500;

/// PDF magic bytes signature (%PDF)
const List<int> _pdfMagicBytes = [0x25, 0x50, 0x44, 0x46];

/// Service for parsing Kaspi Gold PDF statements
/// Extracts transfer information and calculates statistics
class PdfParserService {
  // Cache compiled RegExp patterns for better performance
  static final RegExp _namePattern =
      RegExp(AppConstants.namePatternString);
  static final RegExp _cardPattern =
      RegExp(AppConstants.cardPatternString);
  static final RegExp _amountPattern =
      RegExp(AppConstants.amountPatternString);
  static final RegExp _periodPattern1 =
      RegExp(AppConstants.periodPattern1String);
  static final RegExp _periodPattern2 =
      RegExp(AppConstants.periodPattern2String);
  static final RegExp _periodPattern3 =
      RegExp(AppConstants.periodPattern3String, caseSensitive: false);

  /// Parses PDF file and returns analysis results
  ///
  /// Throws:
  /// - [FileTooLargeException] if file exceeds size limit
  /// - [InvalidFileFormatException] if file is not PDF
  /// - [FileReadException] if file cannot be read
  /// - [PdfParsingException] if PDF parsing fails
  /// - [OperationTimeoutException] if parsing takes too long
  Future<AnalysisResult> parsePdf(String filePath) async {
    // Validate file before processing
    await _validateFile(filePath);

    try {
      // Parse with timeout to prevent hanging
      return await _parsePdfWithTimeout(filePath);
    } on TimeoutException {
      throw OperationTimeoutException(
        timeoutSeconds: AppConstants.parsingTimeoutSeconds,
      );
    } on PdfParsingException {
      rethrow;
    } catch (e, stackTrace) {
      throw PdfParsingException(
        details: e.toString(),
        originalError: {'error': e, 'stackTrace': stackTrace},
      );
    }
  }

  /// Validates file before parsing
  Future<void> _validateFile(String filePath) async {
    // Security: Validate path to prevent Path Traversal attacks
    _validatePath(filePath);

    final file = File(filePath);

    // Check if file exists
    if (!await file.exists()) {
      throw FileReadException(filePath: filePath);
    }

    // Check file extension
    if (!filePath.toLowerCase().endsWith('.pdf')) {
      final extension = filePath.split('.').last;
      throw InvalidFileFormatException(extension: extension);
    }

    // Check file size
    final fileSize = await file.length();
    if (fileSize > AppConstants.maxFileSizeBytes) {
      throw FileTooLargeException(
        fileSizeBytes: fileSize,
        maxSizeBytes: AppConstants.maxFileSizeBytes,
      );
    }

    // Security: Validate MIME type by checking magic bytes
    await _validateMimeType(file);
  }

  /// Validates file path to prevent Path Traversal attacks
  void _validatePath(String filePath) {
    // Normalize the path to resolve .. and . components
    final normalizedPath = p.normalize(filePath);

    // Check for path traversal patterns
    if (filePath.contains('..') ||
        normalizedPath != filePath ||
        !p.isAbsolute(normalizedPath)) {
      throw PdfParsingException(
        details: 'Invalid file path: potential path traversal detected',
      );
    }
  }

  /// Validates PDF MIME type by checking magic bytes
  Future<void> _validateMimeType(File file) async {
    final randomAccess = await file.open(mode: FileMode.read);
    try {
      final header = await randomAccess.read(_pdfMagicBytes.length);

      if (header.length < _pdfMagicBytes.length) {
        throw InvalidFileFormatException(extension: 'unknown');
      }

      for (int i = 0; i < _pdfMagicBytes.length; i++) {
        if (header[i] != _pdfMagicBytes[i]) {
          throw InvalidFileFormatException(extension: 'not-pdf');
        }
      }
    } finally {
      await randomAccess.close();
    }
  }

  /// Parses PDF with timeout protection
  Future<AnalysisResult> _parsePdfWithTimeout(String filePath) async {
    return await Future.any([
      _parsePdfInternal(filePath),
      Future.delayed(
        Duration(seconds: AppConstants.parsingTimeoutSeconds),
        () => throw TimeoutException('PDF parsing timeout'),
      ),
    ]);
  }

  /// Internal PDF parsing logic
  Future<AnalysisResult> _parsePdfInternal(String filePath) async {
    final file = File(filePath);
    PdfDocument? document;

    try {
      // Read file bytes
      final bytes = await file.readAsBytes();
      document = PdfDocument(inputBytes: bytes);

      // Security: Check page count to prevent PDF bomb attacks
      if (document.pages.count > _maxPdfPages) {
        throw PdfParsingException(
          details: 'PDF has too many pages (${document.pages.count}). Maximum allowed: $_maxPdfPages',
        );
      }

      // Extract text from all pages
      final fullText = _extractTextFromDocument(document);

      // Analyze text and return results
      return _analyzeText(fullText);
    } catch (e) {
      throw PdfParsingException(
        details: 'Failed to parse PDF: ${e.toString()}',
        originalError: e,
      );
    } finally {
      // Always dispose document to free memory
      document?.dispose();
    }
  }

  /// Extracts text from all pages in the PDF document
  /// Optimized to create extractor once instead of per-page
  String _extractTextFromDocument(PdfDocument document) {
    final buffer = StringBuffer();
    final extractor = PdfTextExtractor(document);

    for (int i = 0; i < document.pages.count; i++) {
      final pageText = extractor.extractText(
        startPageIndex: i,
        endPageIndex: i,
      );
      buffer.write(pageText);
      buffer.write('\n'); // Add newline between pages
    }

    return buffer.toString();
  }

  /// Analyzes extracted text and builds result
  AnalysisResult _analyzeText(String text) {
    final lines = text.split('\n');
    final uniqueRecipients = <String>{};
    double totalAmount = 0.0;

    // Extract period first (only needs full text, not line-by-line)
    final periodInfo = _extractPeriod(text);

    // Process each line to find transfers
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Skip empty lines
      if (line.isEmpty) continue;

      // Skip lines that match exclusion patterns
      if (_shouldSkipLine(line)) continue;

      // Try to extract transfer info
      final transferInfo = _extractTransferInfo(line, lines, i);

      if (transferInfo != null) {
        uniqueRecipients.add(transferInfo.recipient);
        totalAmount += transferInfo.amount;
      }
    }

    return AnalysisResult(
      peopleCount: uniqueRecipients.length,
      totalAmount: totalAmount,
      periodStart: periodInfo?['start'] ?? '',
      periodEnd: periodInfo?['end'] ?? '',
    );
  }

  /// Extracts period information from text
  Map<String, String>? _extractPeriod(String text) {
    // Try different period patterns
    final patterns = [_periodPattern1, _periodPattern2, _periodPattern3];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return {
          'start': match.group(1)!,
          'end': match.group(2)!,
        };
      }
    }

    return null;
  }

  /// Checks if line should be skipped based on exclusion patterns
  bool _shouldSkipLine(String line) {
    return AppConstants.skipPatterns.any((pattern) => line.contains(pattern));
  }

  /// Extracts transfer information from a line
  TransferInfo? _extractTransferInfo(
    String line,
    List<String> lines,
    int index,
  ) {
    // Pattern 1: Transfer to person by name
    if (line.contains('Перевод')) {
      final nameMatch = _namePattern.firstMatch(line);

      if (nameMatch != null) {
        final recipient = nameMatch.group(1)!;
        final amount = _extractAmount(line, lines, index);

        if (amount != null) {
          return TransferInfo(recipient: recipient, amount: amount);
        }
      }
    }

    // Pattern 2: Transfer to card
    final cardMatch = _cardPattern.firstMatch(line);

    if (cardMatch != null) {
      final bankName = cardMatch.group(1)!.trim();
      final cardDigits = cardMatch.group(2)!;
      final recipient = 'На карту $bankName*$cardDigits';
      final amount = _extractAmount(line, lines, index);

      if (amount != null) {
        return TransferInfo(recipient: recipient, amount: amount);
      }
    }

    return null;
  }

  /// Extracts amount from current or following lines
  double? _extractAmount(String line, List<String> lines, int index) {
    // Try current line first
    var match = _amountPattern.firstMatch(line);

    // If not found, look ahead in next lines
    if (match == null) {
      for (int offset = 1;
          offset <= AppConstants.maxLookAheadLines && index + offset < lines.length;
          offset++) {
        match = _amountPattern.firstMatch(lines[index + offset]);
        if (match != null) break;
      }
    }

    if (match != null) {
      // Clean up amount string and parse
      final amountStr = match
          .group(1)!
          .replaceAll(' ', '')
          .replaceAll(',', '.');

      return double.tryParse(amountStr);
    }

    return null;
  }
}
