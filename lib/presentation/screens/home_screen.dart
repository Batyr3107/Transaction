import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/services/language_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/analysis_result.dart';
import '../../data/services/pdf_parser_service.dart';
import '../widgets/error_message.dart';
import '../widgets/language_switcher.dart';
import '../widgets/privacy_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/upload_button.dart';

/// Main home screen for PDF analysis
class HomeScreen extends StatefulWidget {
  final LanguageService languageService;

  const HomeScreen({
    super.key,
    required this.languageService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PdfParserService _parserService = PdfParserService();

  AnalysisResult? _result;
  bool _isLoading = false;
  String? _error;

  NumberFormat get _numberFormat {
    // Use locale-specific number format
    final locale = widget.languageService.currentLocale.languageCode;
    return NumberFormat('#,###', locale == 'kk' ? 'kk_KZ' : 'ru_RU');
  }

  @override
  Widget build(BuildContext context) {
    return _result != null ? _buildResultScreen() : _buildUploadScreen();
  }

  /// Builds upload screen
  Widget _buildUploadScreen() {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          LanguageSwitcher(languageService: widget.languageService),
          const SizedBox(width: AppTheme.spaceSmall),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spaceHuge),
                UploadButton(
                  isLoading: _isLoading,
                  onTap: _pickAndAnalyzePdf,
                  uploadText: l10n.uploadButton,
                  analyzingText: l10n.analyzing,
                ),
                const SizedBox(height: AppTheme.spaceExtraLarge),
                PrivacyBadge(privacyText: l10n.privacyMessage),
                if (_error != null) ...[
                  const SizedBox(height: AppTheme.spaceLarge),
                  ErrorMessage(message: _error!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds result screen
  Widget _buildResultScreen() {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          LanguageSwitcher(languageService: widget.languageService),
          const SizedBox(width: AppTheme.spaceSmall),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spaceLarge),
                if (_result!.hasPeriod) ...[
                  Text(
                    '${_result!.periodStart} — ${_result!.periodEnd}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spaceLarge),
                ],
                const SizedBox(height: AppTheme.spaceLarge),
                StatCard(
                  icon: Icons.people,
                  value: '${_result!.peopleCount}',
                  label: l10n.peopleCount(_result!.peopleCount),
                  color: AppTheme.infoColor,
                ),
                const SizedBox(height: AppTheme.spaceLarge),
                StatCard(
                  icon: Icons.attach_money,
                  value: '${_numberFormat.format(_result!.totalAmount.round())} ₸',
                  label: l10n.sent,
                  color: AppTheme.successColor,
                ),
                const SizedBox(height: AppTheme.spaceExtraLarge),
                ElevatedButton(
                  onPressed: _reset,
                  child: Text(l10n.loadAnother),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Picks PDF file and analyzes it
  Future<void> _pickAndAnalyzePdf() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      // Pick PDF file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        setState(() => _isLoading = false);
        return;
      }

      final filePath = result.files.single.path!;

      // Parse PDF
      final analysisResult = await _parserService.parsePdf(filePath);

      if (mounted) {
        setState(() {
          _result = analysisResult;
          _isLoading = false;
        });
      }
    } on FileTooLargeException catch (e) {
      if (mounted) {
        setState(() {
          _error = '${l10n.errorFileTooBig}: ${e.details}';
          _isLoading = false;
        });
      }
    } on InvalidFileFormatException catch (e) {
      if (mounted) {
        setState(() {
          _error = '${l10n.errorInvalidFile}: ${e.details}';
          _isLoading = false;
        });
      }
    } on OperationTimeoutException catch (_) {
      if (mounted) {
        setState(() {
          _error = l10n.errorTimeout;
          _isLoading = false;
        });
      }
    } on AppException catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '${l10n.errorUnknown}: $e';
          _isLoading = false;
        });
      }
    }
  }

  /// Resets state to show upload screen
  void _reset() {
    setState(() {
      _result = null;
      _error = null;
    });
  }
}
