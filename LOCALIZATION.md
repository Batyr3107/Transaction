# Локализация / Localization

Kaspi Analyzer поддерживает несколько языков через систему локализации Flutter.

## Поддерживаемые языки

| Язык | Код | Статус |
|------|-----|--------|
| Русский | `ru` | ✅ Полностью переведено |
| Қазақша (Казахский) | `kk` | ✅ Полностью переведено |

## Как это работает

### Архитектура локализации

```
lib/
├── l10n/                      # Папка локализации
│   ├── app_ru.arb            # Русские переводы
│   └── app_kk.arb            # Казахские переводы
├── core/
│   └── services/
│       └── language_service.dart  # Сервис управления языком
└── presentation/
    └── widgets/
        └── language_switcher.dart # Переключатель языка
```

### Технологии

- **flutter_localizations** - Официальная система локализации Flutter
- **intl** - Интернационализация и форматирование
- **shared_preferences** - Сохранение выбранного языка

## Использование

### Переключение языка в приложении

1. Откройте приложение
2. Нажмите на иконку языка (🌐) в правом верхнем углу
3. Выберите язык из списка:
   - **Русский**
   - **Қазақша**

Выбранный язык сохраняется и применяется при следующем запуске.

### Для разработчиков

#### Добавление нового языка

1. **Создайте ARB файл**
   ```bash
   touch lib/l10n/app_<код_языка>.arb
   ```

2. **Скопируйте содержимое из app_ru.arb**
   ```bash
   cp lib/l10n/app_ru.arb lib/l10n/app_<код_языка>.arb
   ```

3. **Переведите все строки**
   ```json
   {
     "@@locale": "en",
     "appTitle": "Kaspi Analyzer",
     "uploadButton": "Upload statement",
     ...
   }
   ```

4. **Добавьте в LanguageService**
   ```dart
   // lib/core/services/language_service.dart
   static const Locale englishLocale = Locale('en');

   static const List<Locale> supportedLocales = [
     russianLocale,
     kazakhLocale,
     englishLocale, // новый язык
   ];
   ```

5. **Обновите getLanguageName**
   ```dart
   String getLanguageName(Locale locale) {
     switch (locale.languageCode) {
       case 'ru':
         return 'Русский';
       case 'kk':
         return 'Қазақша';
       case 'en':
         return 'English'; // новый язык
       default:
         return locale.languageCode;
     }
   }
   ```

6. **Запустите генерацию**
   ```bash
   flutter gen-l10n
   ```

#### Использование переводов в коде

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// В виджете
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Text(l10n.appTitle);
}
```

#### Множественные формы (Plurals)

ARB поддерживает множественные формы:

```json
{
  "peopleCount": "{count, plural, =1{человек} few{человека} other{человек}}",
  "@peopleCount": {
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

Использование:
```dart
Text(l10n.peopleCount(5))  // "5 человек"
Text(l10n.peopleCount(2))  // "2 человека"
```

#### Параметры в строках

```json
{
  "greeting": "Привет, {name}!",
  "@greeting": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

Использование:
```dart
Text(l10n.greeting('Иван'))  // "Привет, Иван!"
```

## Форматирование чисел по локали

Приложение автоматически форматирует числа согласно выбранной локали:

```dart
NumberFormat get _numberFormat {
  final locale = widget.languageService.currentLocale.languageCode;
  return NumberFormat('#,###', locale == 'kk' ? 'kk_KZ' : 'ru_RU');
}
```

**Примеры:**
- Русский: `1 000 000 ₸`
- Казахский: `1 000 000 ₸`

## Структура ARB файла

### Базовая структура

```json
{
  "@@locale": "ru",

  "keyName": "Переведённый текст",
  "@keyName": {
    "description": "Описание для переводчиков"
  }
}
```

### Полный пример (app_ru.arb)

```json
{
  "@@locale": "ru",

  "appTitle": "Kaspi Analyzer",
  "@appTitle": {
    "description": "Application title"
  },

  "uploadButton": "Загрузить выписку",
  "@uploadButton": {
    "description": "Upload button text"
  }
}
```

## Тестирование локализации

### Ручное тестирование

1. Запустите приложение
2. Переключите язык через UI
3. Проверьте все экраны:
   - Главный экран (загрузка)
   - Экран результатов
   - Сообщения об ошибках

### Автоматическое тестирование

```dart
testWidgets('displays text in Russian', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('ru'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: HomeScreen(),
    ),
  );

  expect(find.text('Загрузить выписку'), findsOneWidget);
});
```

## Сохранение выбранного языка

Язык сохраняется в `SharedPreferences` и загружается при запуске:

```dart
// Сохранение
final prefs = await SharedPreferences.getInstance();
await prefs.setString('app_language', 'kk');

// Загрузка
final languageCode = prefs.getString('app_language');
```

## Fallback языка

Если выбранный язык не поддерживается, приложение использует русский:

```dart
Locale _currentLocale = russianLocale; // По умолчанию
```

## Рекомендации по переводу

### Русский язык

- ✅ Используйте вежливую форму
- ✅ Избегайте технического жаргона
- ✅ Короткие, понятные фразы
- ✅ Множественные формы (1 человек, 2 человека, 5 человек)

### Казахский язык

- ✅ Используйте современный казахский (не русицизмы)
- ✅ Уважительный тон
- ✅ Простые слова
- ✅ Проверка у носителей языка

## Известные ограничения

1. **Формат даты**: Использует формат из PDF (не локализуется)
2. **Валюта**: Всегда использует "₸" (тенге)
3. **Числа**: Форматирование может отличаться от ожиданий

## Будущие улучшения

- [ ] Английский язык
- [ ] Автоопределение языка системы
- [ ] Локализация формата даты
- [ ] RTL поддержка (для будущих языков)
- [ ] Перевод сообщений об ошибках PDF парсера

## Вклад в переводы

Если вы нашли ошибку в переводе или хотите добавить новый язык:

1. Создайте Issue с описанием
2. Или создайте Pull Request с изменениями в ARB файлах
3. Укажите источник (носитель языка, профессиональный перевод, и т.д.)

## FAQ

**Q: Как сменить язык по умолчанию?**
A: Измените `_currentLocale` в `LanguageService`:
```dart
Locale _currentLocale = kazakhLocale; // Казахский по умолчанию
```

**Q: Можно ли добавить язык без перезапуска приложения?**
A: Да, язык меняется мгновенно через `LanguageService`.

**Q: Где хранится выбранный язык?**
A: В `SharedPreferences` под ключом `app_language`.

**Q: Как обновить переводы после изменения ARB?**
A: Запустите `flutter gen-l10n` или просто `flutter run` (генерируется автоматически).

## Лицензия

Переводы распространяются под той же лицензией, что и проект (MIT).
