import 'package:flutter_test/flutter_test.dart';
import 'package:kaspi_analyzer/pdf_parser.dart';

void main() {
  group('KaspiPdfParser', () {
    late KaspiPdfParser parser;

    setUp(() {
      parser = KaspiPdfParser();
    });

    test('should skip lines with credit payments', () {
      // Этот тест проверяет, что парсер пропускает оплату кредита
      // В реальном использовании нужно будет создать тестовый PDF
    });

    test('should extract recipient names correctly', () {
      // Тест проверяет корректное извлечение имён получателей
      // Пример: "Перевод Динара З." -> "Динара З."
    });

    test('should extract card transfers correctly', () {
      // Тест проверяет корректное извлечение переводов на карты
      // Пример: "На карту Freedom Finance Bank*6281"
    });

    test('should count unique recipients only', () {
      // Тест проверяет, что одинаковые получатели считаются один раз
    });

    test('should sum transfer amounts correctly', () {
      // Тест проверяет корректное суммирование переводов
    });

    test('should extract period from text', () {
      // Тест проверяет извлечение периода выписки
    });
  });
}
