/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? details;
  final dynamic originalError;

  const AppException(
    this.message, {
    this.details,
    this.originalError,
  });

  @override
  String toString() {
    if (details != null) {
      return '$message: $details';
    }
    return message;
  }
}

/// Thrown when file is too large
class FileTooLargeException extends AppException {
  final int fileSizeBytes;
  final int maxSizeBytes;

  const FileTooLargeException({
    required this.fileSizeBytes,
    required this.maxSizeBytes,
  }) : super(
          'Файл слишком большой',
          details: 'Размер файла: ${fileSizeBytes ~/ 1024 ~/ 1024} МБ, '
              'максимально: ${maxSizeBytes ~/ 1024 ~/ 1024} МБ',
        );
}

/// Thrown when file format is invalid
class InvalidFileFormatException extends AppException {
  final String extension;

  const InvalidFileFormatException({
    required this.extension,
  }) : super(
          'Неверный формат файла',
          details: 'Ожидается PDF, получен: $extension',
        );
}

/// Thrown when PDF parsing fails
class PdfParsingException extends AppException {
  const PdfParsingException({
    String? details,
    dynamic originalError,
  }) : super(
          'Ошибка при парсинге PDF',
          details: details,
          originalError: originalError,
        );
}

/// Thrown when operation times out
class OperationTimeoutException extends AppException {
  final int timeoutSeconds;

  const OperationTimeoutException({
    required this.timeoutSeconds,
  }) : super(
          'Превышено время ожидания',
          details: 'Операция заняла больше $timeoutSeconds секунд',
        );
}

/// Thrown when file cannot be read
class FileReadException extends AppException {
  final String filePath;

  const FileReadException({
    required this.filePath,
    dynamic originalError,
  }) : super(
          'Не удалось прочитать файл',
          details: filePath,
          originalError: originalError,
        );
}

/// Thrown for unexpected errors
class UnexpectedErrorException extends AppException {
  const UnexpectedErrorException({
    String? details,
    dynamic originalError,
  }) : super(
          'Произошла неожиданная ошибка',
          details: details,
          originalError: originalError,
        );
}
