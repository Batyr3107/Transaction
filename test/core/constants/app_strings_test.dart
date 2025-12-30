import 'package:flutter_test/flutter_test.dart';
import 'package:kaspi_analyzer/core/constants/app_strings.dart';

void main() {
  group('AppStrings.getPeoplePlural', () {
    test('returns "человек" for 1', () {
      expect(AppStrings.getPeoplePlural(1), 'человек');
    });

    test('returns "человек" for 11', () {
      expect(AppStrings.getPeoplePlural(11), 'человек');
    });

    test('returns "человек" for 21', () {
      expect(AppStrings.getPeoplePlural(21), 'человек');
    });

    test('returns "человека" for 2', () {
      expect(AppStrings.getPeoplePlural(2), 'человека');
    });

    test('returns "человека" for 3', () {
      expect(AppStrings.getPeoplePlural(3), 'человека');
    });

    test('returns "человека" for 4', () {
      expect(AppStrings.getPeoplePlural(4), 'человека');
    });

    test('returns "человека" for 22', () {
      expect(AppStrings.getPeoplePlural(22), 'человека');
    });

    test('returns "человек" for 12', () {
      expect(AppStrings.getPeoplePlural(12), 'человек');
    });

    test('returns "человек" for 13', () {
      expect(AppStrings.getPeoplePlural(13), 'человек');
    });

    test('returns "человек" for 14', () {
      expect(AppStrings.getPeoplePlural(14), 'человек');
    });

    test('returns "человек" for 5', () {
      expect(AppStrings.getPeoplePlural(5), 'человек');
    });

    test('returns "человек" for 0', () {
      expect(AppStrings.getPeoplePlural(0), 'человек');
    });

    test('returns "человек" for 100', () {
      expect(AppStrings.getPeoplePlural(100), 'человек');
    });
  });
}
