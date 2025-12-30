import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app language
class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'app_language';

  // Supported locales
  static const Locale russianLocale = Locale('ru');
  static const Locale kazakhLocale = Locale('kk');

  static const List<Locale> supportedLocales = [
    russianLocale,
    kazakhLocale,
  ];

  Locale _currentLocale = russianLocale;

  /// Current selected locale
  Locale get currentLocale => _currentLocale;

  /// Initialize language service and load saved language
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey);

    if (languageCode != null) {
      _currentLocale = Locale(languageCode);
      notifyListeners();
    }
  }

  /// Change app language
  Future<void> changeLanguage(Locale locale) async {
    if (_currentLocale == locale) return;

    _currentLocale = locale;
    notifyListeners();

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
  }

  /// Get language name for display
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ru':
        return 'Русский';
      case 'kk':
        return 'Қазақша';
      default:
        return locale.languageCode;
    }
  }

  /// Check if locale is supported
  bool isSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }
}
