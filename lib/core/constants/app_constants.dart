/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Kaspi Analyzer';
  static const String appVersion = '1.0.0';

  // File Validation
  static const int maxFileSizeMB = 50;
  static const int maxFileSizeBytes = maxFileSizeMB * 1024 * 1024;
  static const List<String> allowedExtensions = ['pdf'];

  // Parsing
  static const int parsingTimeoutSeconds = 60;
  static const int maxLookAheadLines = 2;

  // Skip Patterns (case-sensitive)
  static const List<String> skipPatterns = [
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

  // RegEx Patterns
  static const String namePatternString = r'([А-ЯЁA-Z][а-яёa-z]+\s+[А-ЯЁA-Z](?:[а-яёa-z]+|\.)?)';
  static const String cardPatternString = r'На карту\s+([^*]+)\*(\d+)';
  static const String amountPatternString = r'-\s*(\d[\d\s]*(?:[.,]\d{2})?)(?:\s*₸)?';

  static const String periodPattern1String = r'с\s+(\d{2}\.\d{2}\.\d{2,4})\s+по\s+(\d{2}\.\d{2}\.\d{2,4})';
  static const String periodPattern2String = r'(\d{2}\.\d{2}\.\d{2,4})\s*[-—]\s*(\d{2}\.\d{2}\.\d{2,4})';
  static const String periodPattern3String = r'период[:\s]+(\d{2}\.\d{2}\.\d{2,4})\s*[-—]\s*(\d{2}\.\d{2}\.\d{2,4})';
}
