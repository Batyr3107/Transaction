import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/services/language_service.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final languageService = LanguageService();
  final themeService = ThemeService();

  await Future.wait([
    languageService.initialize(),
    themeService.initialize(),
  ]);

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(KaspiAnalyzerApp(
    languageService: languageService,
    themeService: themeService,
  ));
}

/// Root application widget with theme and language support
class KaspiAnalyzerApp extends StatefulWidget {
  final LanguageService languageService;
  final ThemeService themeService;

  const KaspiAnalyzerApp({
    super.key,
    required this.languageService,
    required this.themeService,
  });

  @override
  State<KaspiAnalyzerApp> createState() => _KaspiAnalyzerAppState();
}

class _KaspiAnalyzerAppState extends State<KaspiAnalyzerApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        widget.languageService,
        widget.themeService,
      ]),
      builder: (context, child) {
        final isDark = widget.themeService.isDarkMode;

        // Update system UI based on theme
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarColor: isDark
                ? AppTheme.darkBackground
                : AppTheme.lightBackground,
            systemNavigationBarIconBrightness:
                isDark ? Brightness.light : Brightness.dark,
          ),
        );

        return MaterialApp(
          title: 'Kaspi Analyzer',
          debugShowCheckedModeBanner: false,

          // Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _getThemeMode(),

          // Localization
          locale: widget.languageService.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LanguageService.supportedLocales,

          // Home
          home: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _showSplash
                ? SplashScreen(
                    key: const ValueKey('splash'),
                    onAnimationComplete: () {
                      setState(() => _showSplash = false);
                    },
                  )
                : HomeScreen(
                    key: const ValueKey('home'),
                    languageService: widget.languageService,
                    themeService: widget.themeService,
                  ),
          ),
        );
      },
    );
  }

  ThemeMode _getThemeMode() {
    switch (widget.themeService.themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}
