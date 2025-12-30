import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/services/language_service.dart';
import '../../core/theme/app_theme.dart';

/// Language switcher button widget
class LanguageSwitcher extends StatelessWidget {
  final LanguageService languageService;

  const LanguageSwitcher({
    super.key,
    required this.languageService,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopupMenuButton<Locale>(
      icon: const Icon(
        Icons.language,
        color: AppTheme.textSecondary,
      ),
      tooltip: l10n.language,
      onSelected: (Locale locale) {
        languageService.changeLanguage(locale);
      },
      itemBuilder: (BuildContext context) {
        return LanguageService.supportedLocales.map((Locale locale) {
          final isSelected = languageService.currentLocale == locale;

          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: AppTheme.primaryColor,
                    size: 20,
                  )
                else
                  const SizedBox(width: 20),
                const SizedBox(width: AppTheme.spaceSmall),
                Text(
                  languageService.getLanguageName(locale),
                  style: TextStyle(
                    color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}
