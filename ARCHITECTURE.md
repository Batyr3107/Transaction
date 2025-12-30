# Architecture Documentation

## Overview

Kaspi Analyzer follows **Clean Architecture** principles with clear separation of concerns.

## Project Structure

```
lib/
├── core/                      # Core functionality, shared across layers
│   ├── constants/            # Application constants
│   │   ├── app_constants.dart    # Business logic constants
│   │   └── app_strings.dart      # UI strings (localization ready)
│   ├── theme/                # Application theme
│   │   └── app_theme.dart        # Colors, typography, dimensions
│   ├── utils/                # Utility functions (future)
│   └── errors/               # Custom exceptions
│       └── app_exceptions.dart   # App-specific exceptions
│
├── data/                      # Data layer
│   ├── models/               # Data models (immutable)
│   │   ├── analysis_result.dart  # Analysis result model
│   │   └── transfer_info.dart    # Transfer information model
│   └── services/             # Services
│       └── pdf_parser_service.dart  # PDF parsing logic
│
└── presentation/              # Presentation layer (UI)
    ├── screens/              # Full screens
    │   └── home_screen.dart      # Main screen with state management
    └── widgets/              # Reusable widgets
        ├── stat_card.dart        # Statistics card widget
        ├── upload_button.dart    # Upload button widget
        ├── error_message.dart    # Error display widget
        └── privacy_badge.dart    # Privacy info widget
```

## Layer Responsibilities

### Core Layer
- **Purpose**: Shared functionality across all layers
- **Contains**: Constants, themes, utilities, errors
- **Dependencies**: None (independent)
- **Rules**: No imports from data or presentation layers

### Data Layer
- **Purpose**: Data management and business logic
- **Contains**: Models, services, repositories (future)
- **Dependencies**: Core layer only
- **Rules**:
  - Models must be immutable
  - Services handle business logic
  - No UI code

### Presentation Layer
- **Purpose**: User interface and state management
- **Contains**: Screens, widgets
- **Dependencies**: Core and Data layers
- **Rules**:
  - Screens manage state
  - Widgets are reusable and stateless when possible
  - No business logic (delegate to services)

## Design Patterns

### 1. Service Pattern
- `PdfParserService`: Encapsulates PDF parsing logic
- Stateless, reusable
- Throws custom exceptions for error handling

### 2. Immutable Models
- All data models are `@immutable`
- Use `copyWith` for modifications
- Implement `==` and `hashCode`
- Support JSON serialization

### 3. Custom Exceptions
- Type-safe error handling
- Descriptive error messages
- Preserve original error for debugging

### 4. Widget Composition
- Small, focused widgets
- Reusable components
- Separation of concerns

## Data Flow

```
User Interaction (UI)
       ↓
Screen (State Management)
       ↓
Service (Business Logic)
       ↓
Model (Data Structure)
       ↓
Screen (Update UI)
       ↓
Widget (Display)
```

## Best Practices Applied

### Code Organization
- ✅ Layered architecture
- ✅ Single Responsibility Principle
- ✅ Dependency Inversion

### Performance
- ✅ Const constructors where possible
- ✅ Cached RegExp patterns
- ✅ StringBuffer for text concatenation
- ✅ Proper resource disposal (PDF document)
- ✅ Timeout protection

### Error Handling
- ✅ Type-safe exceptions
- ✅ Validation before processing
- ✅ User-friendly error messages
- ✅ Graceful degradation

### Testing
- ✅ Unit tests for models
- ✅ Unit tests for utilities
- ✅ Widget tests for components
- ✅ Testable architecture

### Code Quality
- ✅ Immutability
- ✅ Type safety
- ✅ Documentation
- ✅ Consistent naming
- ✅ DRY principle

## Future Improvements

### State Management
Consider adding proper state management for complex scenarios:
- **Provider**: Simple, recommended by Flutter
- **Riverpod**: Modern Provider alternative
- **Bloc**: For complex state logic

### Dependency Injection
For better testability and flexibility:
- **get_it**: Simple service locator
- **injectable**: Code generation for DI

### Localization
Replace AppStrings with proper l10n:
- **flutter_localizations**: Official Flutter solution
- **intl**: Internationalization support

### Repository Pattern
If adding data persistence:
```
data/
├── repositories/
│   └── analysis_repository.dart
├── datasources/
│   ├── local/
│   └── remote/
```

### Use Cases
For complex business logic:
```
domain/
├── entities/
├── repositories/
└── usecases/
    └── analyze_pdf_usecase.dart
```

## Testing Strategy

### Unit Tests
- Models: Test immutability, equality, serialization
- Services: Test business logic, error cases
- Utils: Test helper functions

### Widget Tests
- Widgets: Test rendering, interaction
- Screens: Test state changes, navigation

### Integration Tests
- End-to-end flows
- File picking + parsing + display

## Performance Considerations

### PDF Parsing
- ⚡ Single PdfTextExtractor instance
- ⚡ StringBuffer for concatenation
- ⚡ Cached RegExp patterns
- ⚡ Timeout protection (60s)
- ⚡ File size validation (50MB limit)

### UI Rendering
- ⚡ Const constructors
- ⚡ Widget reusability
- ⚡ Minimal rebuilds
- ⚡ Lazy evaluation

### Memory Management
- ⚡ Dispose PDF documents
- ⚡ Clear results when resetting
- ⚡ No memory leaks in state

## Security Considerations

### Privacy
- ✅ No INTERNET permission
- ✅ Data stays on device
- ✅ No analytics/tracking
- ✅ No data persistence

### Validation
- ✅ File type validation
- ✅ File size limits
- ✅ Timeout protection
- ✅ Error boundaries

## Code Style

Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:
- Use `const` constructors
- Prefer `final` over `var`
- Use trailing commas
- Document public APIs
- Descriptive names

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.
