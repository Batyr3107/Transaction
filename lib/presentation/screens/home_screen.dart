import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/services/language_service.dart';
import '../../core/services/theme_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/analysis_result.dart';
import '../../data/services/pdf_parser_service.dart';
import '../widgets/error_message.dart';
import '../widgets/language_switcher.dart';
import '../widgets/privacy_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/theme_switcher.dart';
import '../widgets/upload_button.dart';

/// Main home screen for PDF analysis with beautiful animations
class HomeScreen extends StatefulWidget {
  final LanguageService languageService;
  final ThemeService themeService;

  const HomeScreen({
    super.key,
    required this.languageService,
    required this.themeService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final PdfParserService _parserService = PdfParserService();

  AnalysisResult? _result;
  bool _isLoading = false;
  String? _error;

  NumberFormat get _numberFormat {
    final locale = widget.languageService.currentLocale.languageCode;
    return NumberFormat('#,###', locale == 'kk' ? 'kk_KZ' : 'ru_RU');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppTheme.durationSlow,
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: _result != null
            ? _ResultScreen(
                key: const ValueKey('result'),
                result: _result!,
                languageService: widget.languageService,
                themeService: widget.themeService,
                numberFormat: _numberFormat,
                onReset: _reset,
                onShare: _shareResult,
              )
            : _UploadScreen(
                key: const ValueKey('upload'),
                isLoading: _isLoading,
                error: _error,
                languageService: widget.languageService,
                themeService: widget.themeService,
                onUpload: _pickAndAnalyzePdf,
                onDismissError: () => setState(() => _error = null),
              ),
      ),
    );
  }

  Future<void> _pickAndAnalyzePdf() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        setState(() => _isLoading = false);
        return;
      }

      final filePath = result.files.single.path!;
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

  void _reset() {
    setState(() {
      _result = null;
      _error = null;
    });
  }

  Future<void> _shareResult() async {
    if (_result == null) return;

    final l10n = AppLocalizations.of(context)!;
    final text = '''
${l10n.appTitle}
${_result!.hasPeriod ? '${_result!.periodStart} — ${_result!.periodEnd}\n' : ''}
${l10n.peopleCount(_result!.peopleCount)}: ${_result!.peopleCount}
${l10n.sent}: ${_numberFormat.format(_result!.totalAmount.round())} ₸
''';

    await Share.share(text.trim());
  }
}

/// Upload screen with beautiful animations
class _UploadScreen extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final LanguageService languageService;
  final ThemeService themeService;
  final VoidCallback onUpload;
  final VoidCallback onDismissError;

  const _UploadScreen({
    super.key,
    required this.isLoading,
    required this.error,
    required this.languageService,
    required this.themeService,
    required this.onUpload,
    required this.onDismissError,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = AppTheme.isDark(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppTheme.darkBackground, AppTheme.darkSurface]
              : [AppTheme.lightBackground, AppTheme.lightSurface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            // Background decoration
            _BackgroundDecoration(isDark: isDark),

            // Main content
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                children: [
                  // App bar
                  _AppBar(
                    languageService: languageService,
                    themeService: themeService,
                  ),

                  // Spacer
                  const Spacer(),

                  // Title
                  _buildTitle(context, l10n),

                  const SizedBox(height: AppTheme.spaceXXL),

                  // Upload button
                  UploadButton(
                    isLoading: isLoading,
                    onTap: onUpload,
                    uploadText: l10n.uploadButton,
                    analyzingText: l10n.analyzing,
                  ),

                  const SizedBox(height: AppTheme.spaceXL),

                  // Privacy badge
                  PrivacyBadge(privacyText: l10n.privacyMessage),

                  // Error message
                  if (error != null) ...[
                    const SizedBox(height: AppTheme.spaceLarge),
                    ErrorMessage(
                      message: error!,
                      onDismiss: onDismissError,
                    ),
                  ],

                  // Spacer
                  const Spacer(),

                  // Footer
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.kaspiGradient.createShader(bounds),
          child: Text(
            l10n.appTitle,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: -0.2, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),
        const SizedBox(height: AppTheme.spaceSmall),
        Text(
          'Smart Financial Insights',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryColor(context),
                fontWeight: FontWeight.w500,
              ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Text(
      'v2.0.0',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textSecondaryColor(context).withValues(alpha: 0.5),
          ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 600.ms);
  }
}

/// Result screen with beautiful stat cards
class _ResultScreen extends StatelessWidget {
  final AnalysisResult result;
  final LanguageService languageService;
  final ThemeService themeService;
  final NumberFormat numberFormat;
  final VoidCallback onReset;
  final VoidCallback onShare;

  const _ResultScreen({
    super.key,
    required this.result,
    required this.languageService,
    required this.themeService,
    required this.numberFormat,
    required this.onReset,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = AppTheme.isDark(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppTheme.darkBackground, AppTheme.darkSurface]
              : [AppTheme.lightBackground, AppTheme.lightSurface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            children: [
              // App bar
              _AppBar(
                languageService: languageService,
                themeService: themeService,
              ),

              const SizedBox(height: AppTheme.spaceXL),

              // Success header
              _buildSuccessHeader(context, l10n),

              const SizedBox(height: AppTheme.spaceLarge),

              // Period
              if (result.hasPeriod)
                _buildPeriodBadge(context),

              const SizedBox(height: AppTheme.spaceXL),

              // Stats
              _buildStats(context, l10n),

              const SizedBox(height: AppTheme.spaceXXL),

              // Actions
              _buildActions(context, l10n),

              const SizedBox(height: AppTheme.spaceLarge),

              // Privacy reminder
              PrivacyBadge(privacyText: l10n.privacyMessage),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          decoration: BoxDecoration(
            gradient: AppTheme.successGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.successGlow,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: AppTheme.iconXL,
            color: Colors.white,
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              duration: 500.ms,
              curve: Curves.elasticOut,
            )
            .fadeIn(duration: 300.ms),

        const SizedBox(height: AppTheme.spaceMedium),

        Text(
          l10n.appTitle,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryColor(context),
              ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms)
            .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildPeriodBadge(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMedium,
        vertical: AppTheme.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: AppTheme.iconSmall,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: AppTheme.spaceSmall),
          Text(
            '${result.periodStart} — ${result.periodEnd}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 300.ms);
  }

  Widget _buildStats(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        // People count card
        StatCard(
          icon: Icons.people_alt_rounded,
          value: '${result.peopleCount}',
          label: l10n.peopleCount(result.peopleCount),
          color: AppTheme.infoColor,
          animationDelay: 400,
        ),

        const SizedBox(height: AppTheme.spaceMedium),

        // Amount card
        StatCard(
          icon: Icons.account_balance_wallet_rounded,
          value: '${numberFormat.format(result.totalAmount.round())} ₸',
          label: l10n.sent,
          color: AppTheme.successColor,
          animationDelay: 550,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.share_rounded),
            label: const Text('Share'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingMedium),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 700.ms)
            .slideX(begin: -0.2, end: 0, duration: 400.ms, delay: 700.ms),

        const SizedBox(width: AppTheme.spaceMedium),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.upload_file_rounded),
            label: Text(l10n.loadAnother),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.paddingMedium),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 800.ms)
            .slideX(begin: 0.2, end: 0, duration: 400.ms, delay: 800.ms),
      ],
    );
  }
}

/// App bar with settings
class _AppBar extends StatelessWidget {
  final LanguageService languageService;
  final ThemeService themeService;

  const _AppBar({
    required this.languageService,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ThemeSwitcher(themeService: themeService),
        const SizedBox(width: AppTheme.spaceSmall),
        LanguageSwitcher(languageService: languageService),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .slideY(begin: -0.3, end: 0, duration: 400.ms, delay: 100.ms);
  }
}

/// Background decoration with animated circles
class _BackgroundDecoration extends StatelessWidget {
  final bool isDark;

  const _BackgroundDecoration({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top right circle
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryColor.withValues(alpha: isDark ? 0.12 : 0.08),
                  AppTheme.primaryColor.withValues(alpha: 0),
                ],
              ),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 800.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 600.ms),
        ),

        // Bottom left circle
        Positioned(
          bottom: -150,
          left: -150,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.infoColor.withValues(alpha: isDark ? 0.08 : 0.05),
                  AppTheme.infoColor.withValues(alpha: 0),
                ],
              ),
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0, 0),
                end: const Offset(1, 1),
                duration: 1000.ms,
                delay: 200.ms,
                curve: Curves.easeOutCubic,
              )
              .fadeIn(duration: 600.ms),
        ),
      ],
    );
  }
}
