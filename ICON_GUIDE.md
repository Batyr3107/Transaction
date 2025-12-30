# Руководство по созданию иконки приложения

## ⚠️ Важно

В данный момент приложение использует стандартную системную иконку Android. Перед публикацией в Google Play **обязательно** замените её на собственную иконку.

## 🎨 Требования к иконке

### Размеры иконок для Android

Создайте PNG файлы с именем `ic_launcher.png` следующих размеров:

| Папка | Размер | Разрешение |
|-------|--------|------------|
| `mipmap-mdpi` | 48x48 px | ~160 dpi |
| `mipmap-hdpi` | 72x72 px | ~240 dpi |
| `mipmap-xhdpi` | 96x96 px | ~320 dpi |
| `mipmap-xxhdpi` | 144x144 px | ~480 dpi |
| `mipmap-xxxhdpi` | 192x192 px | ~640 dpi |

### Дополнительно (опционально)

- **Adaptive Icon** (для Android 8.0+):
  - `ic_launcher_foreground.png` - передний слой (108x108 dp)
  - `ic_launcher_background.png` - задний слой (108x108 dp)
- **Google Play**: 512x512 px (для страницы приложения в магазине)

## 🚀 Быстрый способ: Автоматическая генерация

### Вариант 1: Flutter Launcher Icons (рекомендуется)

1. Добавьте в `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/icon.png"
  adaptive_icon_background: "#F44336"  # Красный цвет Kaspi
  adaptive_icon_foreground: "assets/icon_foreground.png"
```

2. Создайте иконку 1024x1024 px и сохраните как `assets/icon.png`

3. Запустите генератор:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### Вариант 2: Онлайн генераторы

Используйте один из сервисов:
- [https://romannurik.github.io/AndroidAssetStudio/](https://romannurik.github.io/AndroidAssetStudio/)
- [https://easyappicon.com/](https://easyappicon.com/)
- [https://icon.kitchen/](https://icon.kitchen/)

Загрузите изображение 512x512 px и скачайте все размеры.

## 📁 Куда поместить файлы

Скопируйте PNG файлы в соответствующие папки:

```
android/app/src/main/res/
├── mipmap-mdpi/ic_launcher.png     (48x48)
├── mipmap-hdpi/ic_launcher.png     (72x72)
├── mipmap-xhdpi/ic_launcher.png    (96x96)
├── mipmap-xxhdpi/ic_launcher.png   (144x144)
└── mipmap-xxxhdpi/ic_launcher.png  (192x192)
```

## 🔧 Обновление AndroidManifest.xml

После добавления иконок обновите манифест:

```xml
<application
    android:label="Kaspi Analyzer"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">  <!-- Изменить эту строку -->
```

Текущая версия использует:
```xml
android:icon="@android:drawable/sym_def_app_icon"  <!-- Временная иконка -->
```

## 💡 Рекомендации по дизайну

### Для приложения Kaspi Analyzer:

- **Основной цвет**: #F44336 (Красный Kaspi)
- **Символ**: Буква "K" или иконка документа/PDF
- **Стиль**: Минималистичный, современный
- **Фон**: Однотонный или градиент

### Примеры концептов:

1. **Вариант 1**: Красный круг с белой буквой "K"
2. **Вариант 2**: Иконка документа с красным акцентом
3. **Вариант 3**: Стилизованный график/диаграмма в красных тонах

## ✅ Проверка

После добавления иконки:

1. Пересоберите приложение:
   ```bash
   flutter clean
   flutter build apk
   ```

2. Установите на устройство и проверьте:
   - Иконка видна на главном экране
   - Иконка отображается в списке приложений
   - Иконка соответствует брендингу

## 📝 Важно для публикации

Для Google Play Console потребуется:
- **Иконка приложения**: 512x512 px (PNG, 32-bit)
- **Feature graphic**: 1024x500 px (необязательно, но рекомендуется)
- **Скриншоты**: Минимум 2 штуки

Все изображения должны соответствовать [требованиям Google Play](https://support.google.com/googleplay/android-developer/answer/9866151).
