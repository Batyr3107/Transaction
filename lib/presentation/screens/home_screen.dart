import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_strings.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/analysis_result.dart';
import '../../data/services/pdf_parser_service.dart';
import '../widgets/error_message.dart';
import '../widgets/privacy_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/upload_button.dart';

/// Main home screen for PDF analysis
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PdfParserService _parserService = PdfParserService();
  final NumberFormat _numberFormat = NumberFormat('#,###', 'ru_RU');

  AnalysisResult? _result;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return _result != null ? _buildResultScreen() : _buildUploadScreen();
  }

  /// Builds upload screen
  Widget _buildUploadScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.appTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppTheme.spaceHuge),
                UploadButton(
                  isLoading: _isLoading,
                  onTap: _pickAndAnalyzePdf,
                ),
                const SizedBox(height: AppTheme.spaceExtraLarge),
                const PrivacyBadge(),
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
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.appTitle,
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
                  label: AppStrings.getPeoplePlural(_result!.peopleCount),
                  color: AppTheme.infoColor,
                ),
                const SizedBox(height: AppTheme.spaceLarge),
                StatCard(
                  icon: Icons.attach_money,
                  value: '${_numberFormat.format(_result!.totalAmount.round())} ₸',
                  label: AppStrings.sent,
                  color: AppTheme.successColor,
                ),
                const SizedBox(height: AppTheme.spaceExtraLarge),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text(AppStrings.loadAnother),
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
    } on AppException catch (e) {
      // Handle known exceptions
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        setState(() {
          _error = '${AppStrings.errorUnknown}: $e';
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
