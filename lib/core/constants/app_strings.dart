/// UI string constants
/// TODO: Replace with proper localization (l10n) in future versions
class AppStrings {
  AppStrings._();

  // App
  static const String appTitle = 'Kaspi Analyzer';

  // Upload Screen
  static const String uploadButton = 'Загрузить выписку';
  static const String analyzing = 'Анализ...';
  static const String privacyMessage = 'Данные не покидают устройство';

  // Result Screen
  static const String sent = 'отправлено';
  static const String loadAnother = 'Загрузить другую';

  // Plurals - People count
  static const String peopleOne = 'человек';
  static const String peopleFew = 'человека';
  static const String peopleMany = 'человек';

  // Errors
  static const String errorAnalyzing = 'Ошибка при анализе файла';
  static const String errorFileTooBig = 'Файл слишком большой';
  static const String errorInvalidFile = 'Неверный формат файла';
  static const String errorTimeout = 'Превышено время ожидания';
  static const String errorUnknown = 'Произошла неизвестная ошибка';

  /// Get correct plural form for Russian language
  static String getPeoplePlural(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return peopleOne;
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return peopleFew;
    } else {
      return peopleMany;
    }
  }
}
