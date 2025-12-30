import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class AnalysisResult {
  final int peopleCount;
  final double totalAmount;
  final String periodStart;
  final String periodEnd;

  AnalysisResult({
    required this.peopleCount,
    required this.totalAmount,
    required this.periodStart,
    required this.periodEnd,
  });
}

class KaspiPdfParser {
  // Парсинг PDF файла
  Future<AnalysisResult> parsePdf(String filePath) async {
    final File file = File(filePath);
    final PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());

    String fullText = '';

    // Извлекаем текст из всех страниц
    for (int i = 0; i < document.pages.count; i++) {
      final PdfTextExtractor extractor = PdfTextExtractor(document);
      fullText += extractor.extractText(startPageIndex: i, endPageIndex: i);
    }

    document.dispose();

    // Анализируем текст
    return _analyzeText(fullText);
  }

  AnalysisResult _analyzeText(String text) {
    final lines = text.split('\n');

    // Множество для уникальных получателей
    final Set<String> uniqueRecipients = {};
    double totalAmount = 0.0;
    String periodStart = '';
    String periodEnd = '';

    // Находим период выписки
    final periodMatch = _extractPeriod(text);
    if (periodMatch != null) {
      periodStart = periodMatch['start'] ?? '';
      periodEnd = periodMatch['end'] ?? '';
    }

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Пропускаем строки, которые не считаем переводами людям
      if (_shouldSkipLine(line)) {
        continue;
      }

      // Проверяем, является ли это переводом человеку
      final transferInfo = _extractTransferInfo(line, lines, i);

      if (transferInfo != null) {
        uniqueRecipients.add(transferInfo['recipient']!);
        totalAmount += double.tryParse(transferInfo['amount']!) ?? 0.0;
      }
    }

    return AnalysisResult(
      peopleCount: uniqueRecipients.length,
      totalAmount: totalAmount,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );
  }

  // Извлекаем информацию о периоде выписки
  Map<String, String>? _extractPeriod(String text) {
    // Ищем паттерн периода: "с 01.01.2025 по 31.03.2025" или "01.01.2025 - 31.03.2025"
    final periodRegex1 = RegExp(r'с\s+(\d{2}\.\d{2}\.\d{2,4})\s+по\s+(\d{2}\.\d{2}\.\d{2,4})');
    final periodRegex2 = RegExp(r'(\d{2}\.\d{2}\.\d{2,4})\s*[-—]\s*(\d{2}\.\d{2}\.\d{2,4})');
    final periodRegex3 = RegExp(r'период[:\s]+(\d{2}\.\d{2}\.\d{2,4})\s*[-—]\s*(\d{2}\.\d{2}\.\d{2,4})', caseSensitive: false);

    var match = periodRegex1.firstMatch(text);
    if (match == null) match = periodRegex2.firstMatch(text);
    if (match == null) match = periodRegex3.firstMatch(text);

    if (match != null) {
      return {
        'start': match.group(1)!,
        'end': match.group(2)!,
      };
    }

    return null;
  }

  // Проверяем, нужно ли пропустить эту строку
  bool _shouldSkipLine(String line) {
    final skipPatterns = [
      'Оплата Kaspi Кредита',
      'Kaspi Кредит',
      'Снятие наличных',
      'Комиссия',
      'Покупка',
      'Оплата товаров',
      'Оплата услуг',
      'Пополнение',
      'Возврат',
    ];

    for (final pattern in skipPatterns) {
      if (line.contains(pattern)) {
        return true;
      }
    }

    return false;
  }

  // Извлекаем информацию о переводе
  Map<String, String>? _extractTransferInfo(String line, List<String> lines, int index) {
    // Паттерн 1: "Перевод" + имя человека (например "Динара З.", "Раушан Н.")
    // Ищем "Перевод" и после него имя с первой буквой фамилии
    if (line.contains('Перевод')) {
      // Паттерн имени: Слово начинающееся с заглавной буквы + пробел + заглавная буква + точка
      final namePattern = RegExp(r'([А-ЯЁA-Z][а-яёa-z]+\s+[А-ЯЁA-Z]\.?)');
      final nameMatch = namePattern.firstMatch(line);

      if (nameMatch != null) {
        final recipient = nameMatch.group(1)!;
        final amount = _extractAmount(line, lines, index);

        if (amount != null) {
          return {
            'recipient': recipient,
            'amount': amount,
          };
        }
      }
    }

    // Паттерн 2: "На карту [название банка]*[цифры]"
    final cardPattern = RegExp(r'На карту\s+([^*]+)\*(\d+)');
    final cardMatch = cardPattern.firstMatch(line);

    if (cardMatch != null) {
      final bankName = cardMatch.group(1)!.trim();
      final cardDigits = cardMatch.group(2)!;
      final recipient = 'На карту $bankName*$cardDigits';
      final amount = _extractAmount(line, lines, index);

      if (amount != null) {
        return {
          'recipient': recipient,
          'amount': amount,
        };
      }
    }

    return null;
  }

  // Извлекаем сумму из строки или соседних строк
  String? _extractAmount(String line, List<String> lines, int index) {
    // Ищем сумму в формате: "-1 000.00 ₸" или "-1000.00" или "-1 000,00"
    final amountPattern = RegExp(r'-\s*(\d[\d\s]*(?:[.,]\d{2})?)(?:\s*₸)?');

    // Сначала пробуем текущую строку
    var match = amountPattern.firstMatch(line);

    // Если не нашли, пробуем следующую строку
    if (match == null && index + 1 < lines.length) {
      match = amountPattern.firstMatch(lines[index + 1]);
    }

    // Если не нашли, пробуем следующую строку после этого
    if (match == null && index + 2 < lines.length) {
      match = amountPattern.firstMatch(lines[index + 2]);
    }

    if (match != null) {
      // Убираем пробелы и заменяем запятую на точку
      String amount = match.group(1)!
          .replaceAll(' ', '')
          .replaceAll(',', '.');

      return amount;
    }

    return null;
  }
}
