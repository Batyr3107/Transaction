# Kaspi Analyzer

Простое оффлайн приложение для анализа выписки Kaspi Gold. Показывает количество людей и общую сумму переводов за период.

## Особенности

- ✅ **Полностью оффлайн** - данные не покидают устройство
- ✅ **Простота** - только 2 показателя: количество людей и сумма
- ✅ **Приватность** - без разрешения INTERNET в AndroidManifest
- ✅ **Быстрый анализ** - результат за несколько секунд

## Что анализируется

**Считаются переводы:**
- Переводы людям (например: "Динара З.", "Раушан Н.")
- Переводы на карты других банков ("На карту Freedom Finance Bank*6281")

**НЕ считаются:**
- Оплата Kaspi Кредита
- Покупки в магазинах
- Снятие наличных
- Комиссии

## Требования

- Flutter SDK 3.0.0 или выше
- Android Studio (для сборки Android приложения)
- Устройство/эмулятор Android с API 21+ (Android 5.0+)

## Установка и запуск

### 1. Установка зависимостей

```bash
flutter pub get
```

### 2. Проверка устройств

```bash
flutter devices
```

### 3. Запуск на устройстве/эмуляторе

```bash
flutter run
```

### 4. Сборка APK для релиза

```bash
flutter build apk --release
```

APK файл будет доступен в: `build/app/outputs/flutter-apk/app-release.apk`

## Структура проекта

```
kaspi_analyzer/
├── lib/
│   ├── main.dart              # Основной UI
│   └── pdf_parser.dart        # Парсинг PDF выписки
├── android/
│   ├── app/
│   │   └── src/main/
│   │       ├── AndroidManifest.xml  # БЕЗ разрешения INTERNET
│   │       └── kotlin/...           # MainActivity
│   ├── build.gradle
│   └── settings.gradle
└── pubspec.yaml               # Зависимости
```

## Зависимости

| Пакет | Версия | Назначение |
|-------|--------|------------|
| syncfusion_flutter_pdf | ^26.2.14 | Парсинг PDF файлов |
| file_picker | ^8.1.6 | Выбор PDF файла |
| intl | ^0.19.0 | Форматирование чисел |

## Использование

1. **Откройте приложение**
2. **Нажмите "Загрузить выписку"**
3. **Выберите PDF файл выписки Kaspi Gold**
4. **Просмотрите результаты:**
   - 👥 Количество людей
   - 💸 Общая сумма переводов
5. **Нажмите "Загрузить другую"** для анализа новой выписки

## Публикация в Google Play

### 1. Подготовка

```bash
# Создайте keystore для подписи
keytool -genkey -v -keystore ~/kaspi-analyzer-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias kaspi-analyzer
```

### 2. Настройка подписи

Создайте файл `android/key.properties`:

```properties
storePassword=<ваш пароль>
keyPassword=<ваш пароль>
keyAlias=kaspi-analyzer
storeFile=<путь к .jks файлу>
```

Обновите `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Сборка для публикации

```bash
flutter build appbundle --release
```

AAB файл: `build/app/outputs/bundle/release/app-release.aab`

### 4. Требования для Google Play

**Обязательно:**
- Аккаунт Google Play Developer ($25 единоразово)
- Иконка приложения 512x512 px
- Минимум 2 скриншота (телефон)
- Описание приложения
- Политика конфиденциальности

**Настройки:**
- Категория: Финансы
- Цена: Бесплатно
- Возрастной рейтинг: 3+
- Реклама: Нет

## Лицензия

MIT License

## Контакты

Вопросы и предложения: [ваш email или GitHub]
