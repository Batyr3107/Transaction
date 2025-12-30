import 'package:flutter_test/flutter_test.dart';
import 'package:kaspi_analyzer/data/models/analysis_result.dart';

void main() {
  group('AnalysisResult', () {
    test('creates instance with required fields', () {
      const result = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '01.01.2025',
        periodEnd: '31.01.2025',
      );

      expect(result.peopleCount, 5);
      expect(result.totalAmount, 1000.0);
      expect(result.periodStart, '01.01.2025');
      expect(result.periodEnd, '31.01.2025');
    });

    test('creates empty result', () {
      const result = AnalysisResult.empty();

      expect(result.peopleCount, 0);
      expect(result.totalAmount, 0.0);
      expect(result.periodStart, '');
      expect(result.periodEnd, '');
    });

    test('copyWith creates new instance with updated fields', () {
      const original = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '01.01.2025',
        periodEnd: '31.01.2025',
      );

      final updated = original.copyWith(peopleCount: 10);

      expect(updated.peopleCount, 10);
      expect(updated.totalAmount, 1000.0);
      expect(original.peopleCount, 5);
    });

    test('hasPeriod returns true when period is set', () {
      const result = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '01.01.2025',
        periodEnd: '31.01.2025',
      );

      expect(result.hasPeriod, true);
    });

    test('hasPeriod returns false when period is empty', () {
      const result = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '',
        periodEnd: '',
      );

      expect(result.hasPeriod, false);
    });

    test('hasData returns true when data exists', () {
      const result = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '',
        periodEnd: '',
      );

      expect(result.hasData, true);
    });

    test('hasData returns false for empty result', () {
      const result = AnalysisResult.empty();

      expect(result.hasData, false);
    });

    test('equality works correctly', () {
      const result1 = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '01.01.2025',
        periodEnd: '31.01.2025',
      );

      const result2 = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '01.01.2025',
        periodEnd: '31.01.2025',
      );

      expect(result1, result2);
      expect(result1.hashCode, result2.hashCode);
    });

    test('toJson converts to map correctly', () {
      const result = AnalysisResult(
        peopleCount: 5,
        totalAmount: 1000.0,
        periodStart: '01.01.2025',
        periodEnd: '31.01.2025',
      );

      final json = result.toJson();

      expect(json['peopleCount'], 5);
      expect(json['totalAmount'], 1000.0);
      expect(json['periodStart'], '01.01.2025');
      expect(json['periodEnd'], '31.01.2025');
    });

    test('fromJson creates instance from map', () {
      final json = {
        'peopleCount': 5,
        'totalAmount': 1000.0,
        'periodStart': '01.01.2025',
        'periodEnd': '31.01.2025',
      };

      final result = AnalysisResult.fromJson(json);

      expect(result.peopleCount, 5);
      expect(result.totalAmount, 1000.0);
      expect(result.periodStart, '01.01.2025');
      expect(result.periodEnd, '31.01.2025');
    });
  });
}
