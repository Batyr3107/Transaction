import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/services/language_service.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize language service
  final languageService = LanguageService();
  await languageService.initialize();

  // Set preferred orientations (portrait only)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(KaspiAnalyzerApp(languageService: languageService));
}

/// Root application widget
class KaspiAnalyzerApp extends StatelessWidget {
  final LanguageService languageService;

  const KaspiAnalyzerApp({
    super.key,
    required this.languageService,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: languageService,
      builder: (context, child) {
        return MaterialApp(
          title: 'Kaspi Analyzer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,

          // Localization
          locale: languageService.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LanguageService.supportedLocales,

          home: HomeScreen(languageService: languageService),
        );
      },
    );
  }
}
