import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/services/language_service.dart';
import '../../core/theme/app_theme.dart';

/// Beautiful language switcher button widget
class LanguageSwitcher extends StatelessWidget {
  final LanguageService languageService;

  const LanguageSwitcher({
    super.key,
    required this.languageService,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = AppTheme.isDark(context);

    return PopupMenuButton<Locale>(
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      color: AppTheme.cardColor(context),
      elevation: AppTheme.elevationMedium,
      tooltip: l10n.language,
      onSelected: (Locale locale) {
        languageService.changeLanguage(locale);
      },
      itemBuilder: (BuildContext context) {
        return LanguageService.supportedLocales.map((Locale locale) {
          final isSelected = languageService.currentLocale == locale;

          return PopupMenuItem<Locale>(
            value: locale,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.paddingSmall,
              ),
              child: Row(
                children: [
                  // Language flag/emoji
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withValues(alpha: 0.1)
                          : AppTheme.textSecondaryColor(context).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Center(
                      child: Text(
                        _getLanguageEmoji(locale),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languageService.getLanguageName(locale),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textPrimaryColor(context),
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                        ),
                        Text(
                          _getLanguageNativeName(locale),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme.textSecondaryColor(context),
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.all(AppTheme.paddingSmall),
        decoration: BoxDecoration(
          color: AppTheme.cardColor(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: Border.all(
            color: isDark ? AppTheme.darkDivider : AppTheme.lightDivider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getLanguageEmoji(languageService.currentLocale),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: AppTheme.spaceSmall),
            Icon(
              Icons.expand_more_rounded,
              size: AppTheme.iconSmall,
              color: AppTheme.textSecondaryColor(context),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageEmoji(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return '🇷🇺';
      case 'kk':
        return '🇰🇿';
      default:
        return '🌐';
    }
  }

  String _getLanguageNativeName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Russian';
      case 'kk':
        return 'Kazakh';
      default:
        return locale.languageCode;
    }
  }
}

/// Compact language switcher (icon only)
class LanguageSwitcherCompact extends StatelessWidget {
  final LanguageService languageService;

  const LanguageSwitcherCompact({
    super.key,
    required this.languageService,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showLanguageSheet(context),
      icon: Icon(
        Icons.translate_rounded,
        color: AppTheme.textSecondaryColor(context),
      ),
      tooltip: AppLocalizations.of(context)!.language,
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LanguageBottomSheet(languageService: languageService),
    );
  }
}

/// Bottom sheet for language selection
class _LanguageBottomSheet extends StatelessWidget {
  final LanguageService languageService;

  const _LanguageBottomSheet({required this.languageService});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: AppTheme.paddingMedium),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textSecondaryColor(context).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingLarge),
            child: Text(
              l10n.selectLanguage,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          // Language options
          ...LanguageService.supportedLocales.map((locale) {
            final isSelected = languageService.currentLocale == locale;

            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                      : AppTheme.textSecondaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Center(
                  child: Text(
                    _getLanguageEmoji(locale),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              title: Text(
                languageService.getLanguageName(locale),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textPrimaryColor(context),
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: AppTheme.primaryColor)
                  : null,
              onTap: () {
                languageService.changeLanguage(locale);
                Navigator.pop(context);
              },
            );
          }),

          const SizedBox(height: AppTheme.spaceLarge),
        ],
      ),
    );
  }

  String _getLanguageEmoji(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return '🇷🇺';
      case 'kk':
        return '🇰🇿';
      default:
        return '🌐';
    }
  }
}
