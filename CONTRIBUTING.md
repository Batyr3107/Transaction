# Contributing to Kaspi Analyzer

Thank you for your interest in contributing! This document provides guidelines for development.

## Development Setup

### Prerequisites

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code
- Android SDK (API 21+)

### Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd kaspi_analyzer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run tests**
   ```bash
   flutter test
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Code Standards

### Dart Style Guide

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart):

- ✅ Use `const` constructors when possible
- ✅ Prefer `final` over `var`
- ✅ Use trailing commas for better formatting
- ✅ Document all public APIs
- ✅ Use descriptive variable names

### Code Formatting

```bash
# Format all files
dart format .

# Analyze code
flutter analyze
```

### Naming Conventions

- **Classes**: `PascalCase` (e.g., `PdfParserService`)
- **Files**: `snake_case` (e.g., `pdf_parser_service.dart`)
- **Variables**: `camelCase` (e.g., `analysisResult`)
- **Constants**: `camelCase` (e.g., `maxFileSizeBytes`)
- **Private**: `_prefixWithUnderscore` (e.g., `_parseInternal`)

## Architecture Guidelines

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed architecture documentation.

### Layer Rules

1. **Core Layer**
   - No dependencies on other layers
   - Contains shared functionality

2. **Data Layer**
   - Depends only on Core
   - Contains models and services
   - No UI code

3. **Presentation Layer**
   - Depends on Core and Data
   - Contains screens and widgets
   - No business logic

### File Organization

```
New feature: Exporting results

lib/
├── core/
│   └── constants/
│       └── export_constants.dart      # Export-specific constants
├── data/
│   ├── models/
│   │   └── export_format.dart         # Export format model
│   └── services/
│       └── export_service.dart        # Export logic
└── presentation/
    ├── screens/
    │   └── export_screen.dart         # Export UI
    └── widgets/
        └── export_button.dart         # Export button widget
```

## Testing Requirements

### Test Coverage

- ✅ All models must have unit tests
- ✅ All services must have unit tests
- ✅ All widgets should have widget tests
- ✅ Critical flows need integration tests

### Writing Tests

```dart
// Unit test example
test('model creates correctly', () {
  const model = MyModel(field: 'value');
  expect(model.field, 'value');
});

// Widget test example
testWidgets('widget displays text', (tester) async {
  await tester.pumpWidget(MyWidget());
  expect(find.text('Expected Text'), findsOneWidget);
});
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/data/models/analysis_result_test.dart

# Run with coverage
flutter test --coverage
```

## Pull Request Process

### Before Submitting

1. ✅ Code follows style guide
2. ✅ All tests pass
3. ✅ New code has tests
4. ✅ Documentation updated
5. ✅ No lint warnings

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guide
- [ ] Tests pass locally
- [ ] Documentation updated
```

## Common Tasks

### Adding a New Screen

1. Create screen file in `lib/presentation/screens/`
2. Create widgets in `lib/presentation/widgets/`
3. Add navigation if needed
4. Write widget tests
5. Update documentation

### Adding a New Service

1. Create service in `lib/data/services/`
2. Add custom exceptions in `lib/core/errors/`
3. Write unit tests
4. Document public API

### Adding Constants

1. Add to appropriate file in `lib/core/constants/`
2. Use `static const` when possible
3. Document purpose

### Updating Models

1. Modify model in `lib/data/models/`
2. Update `copyWith`, `==`, `hashCode`
3. Update JSON methods if needed
4. Update tests

## Performance Guidelines

### DO

- ✅ Use `const` constructors
- ✅ Cache expensive computations
- ✅ Dispose resources properly
- ✅ Use `ListView.builder` for lists
- ✅ Minimize widget rebuilds

### DON'T

- ❌ Create new objects in build methods
- ❌ Use `print()` in production code
- ❌ Ignore dispose/cleanup
- ❌ Parse data synchronously without timeout
- ❌ Keep large objects in memory

## Error Handling

### Custom Exceptions

```dart
// Create specific exception
class MyFeatureException extends AppException {
  const MyFeatureException({String? details})
      : super('My feature failed', details: details);
}

// Use in service
if (condition) {
  throw MyFeatureException(details: 'Reason');
}

// Handle in UI
try {
  await service.doSomething();
} on MyFeatureException catch (e) {
  // Show user-friendly message
  showError(e.toString());
}
```

## Documentation

### Code Comments

```dart
/// Brief description of what this does
///
/// More detailed explanation if needed
///
/// Example:
/// ```dart
/// final result = myFunction(param);
/// ```
///
/// Throws:
/// - [MyException] when something goes wrong
String myFunction(String param) {
  // Implementation
}
```

### Updating README

When adding features, update:
- Features list
- Usage instructions
- Requirements if changed

## Git Workflow

### Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `refactor/description` - Code refactoring
- `docs/description` - Documentation updates

### Commit Messages

```
feat: Add export to CSV functionality
fix: Correct amount parsing for negative values
refactor: Extract validation logic to service
docs: Update architecture documentation
test: Add unit tests for ExportService
```

## Questions?

- Check [README.md](README.md) for basic info
- Check [ARCHITECTURE.md](ARCHITECTURE.md) for architecture
- Open an issue for discussion

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
