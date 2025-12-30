import 'package:flutter_test/flutter_test.dart';
import 'package:kaspi_analyzer/core/errors/app_exceptions.dart';

void main() {
  group('AppExceptions', () {
    test('FileTooLargeException creates correct message', () {
      const exception = FileTooLargeException(
        fileSizeBytes: 100 * 1024 * 1024, // 100MB
        maxSizeBytes: 50 * 1024 * 1024,   // 50MB
      );

      expect(exception.message, contains('Файл слишком большой'));
      expect(exception.details, contains('100 МБ'));
      expect(exception.details, contains('50 МБ'));
    });

    test('InvalidFileFormatException creates correct message', () {
      const exception = InvalidFileFormatException(extension: 'docx');

      expect(exception.message, contains('Неверный формат файла'));
      expect(exception.details, contains('docx'));
    });

    test('PdfParsingException creates correct message', () {
      const exception = PdfParsingException(
        details: 'Corrupted PDF',
      );

      expect(exception.message, contains('Ошибка при парсинге PDF'));
      expect(exception.details, 'Corrupted PDF');
    });

    test('OperationTimeoutException creates correct message', () {
      const exception = OperationTimeoutException(timeoutSeconds: 60);

      expect(exception.message, contains('Превышено время ожидания'));
      expect(exception.details, contains('60 секунд'));
    });

    test('FileReadException creates correct message', () {
      const exception = FileReadException(filePath: '/path/to/file.pdf');

      expect(exception.message, contains('Не удалось прочитать файл'));
      expect(exception.details, '/path/to/file.pdf');
    });

    test('UnexpectedErrorException creates correct message', () {
      const exception = UnexpectedErrorException(
        details: 'Something went wrong',
      );

      expect(exception.message, contains('Произошла неожиданная ошибка'));
      expect(exception.details, 'Something went wrong');
    });

    test('toString includes details when present', () {
      const exception = PdfParsingException(details: 'Test details');

      expect(exception.toString(), contains('Test details'));
    });

    test('toString without details shows only message', () {
      const exception = PdfParsingException();

      expect(exception.toString(), equals(exception.message));
    });
  });
}
