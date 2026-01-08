import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode options
enum AppThemeMode {
  system,
  light,
  dark,
}

/// Service for managing app theme (light/dark mode)
class ThemeService extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';

  AppThemeMode _themeMode = AppThemeMode.system;
  SharedPreferences? _prefs;

  /// Current theme mode setting
  AppThemeMode get themeMode => _themeMode;

  /// Returns the actual brightness based on current mode
  Brightness get brightness {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  /// Returns true if dark mode is active
  bool get isDarkMode => brightness == Brightness.dark;

  /// Initialize service and load saved preference
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    final savedMode = _prefs?.getString(_themeModeKey);

    if (savedMode != null) {
      _themeMode = AppThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => AppThemeMode.system,
      );
    }

    notifyListeners();
  }

  /// Set theme mode and persist to storage
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await _prefs?.setString(_themeModeKey, mode.name);
    notifyListeners();
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? AppThemeMode.light : AppThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Cycle through all theme modes: system -> light -> dark -> system
  Future<void> cycleThemeMode() async {
    final nextIndex = (_themeMode.index + 1) % AppThemeMode.values.length;
    await setThemeMode(AppThemeMode.values[nextIndex]);
  }
}
