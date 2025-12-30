import 'package:flutter/foundation.dart';

/// Represents the result of PDF analysis
/// This class is immutable to prevent accidental modifications
@immutable
class AnalysisResult {
  /// Number of unique recipients
  final int peopleCount;

  /// Total amount transferred
  final double totalAmount;

  /// Start date of the statement period
  final String periodStart;

  /// End date of the statement period
  final String periodEnd;

  const AnalysisResult({
    required this.peopleCount,
    required this.totalAmount,
    required this.periodStart,
    required this.periodEnd,
  });

  /// Creates empty result
  const AnalysisResult.empty()
      : peopleCount = 0,
        totalAmount = 0.0,
        periodStart = '',
        periodEnd = '';

  /// Creates a copy with optional field replacements
  AnalysisResult copyWith({
    int? peopleCount,
    double? totalAmount,
    String? periodStart,
    String? periodEnd,
  }) {
    return AnalysisResult(
      peopleCount: peopleCount ?? this.peopleCount,
      totalAmount: totalAmount ?? this.totalAmount,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
    );
  }

  /// Checks if period information is available
  bool get hasPeriod => periodStart.isNotEmpty && periodEnd.isNotEmpty;

  /// Checks if result has any data
  bool get hasData => peopleCount > 0 || totalAmount > 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalysisResult &&
        other.peopleCount == peopleCount &&
        other.totalAmount == totalAmount &&
        other.periodStart == periodStart &&
        other.periodEnd == periodEnd;
  }

  @override
  int get hashCode {
    return Object.hash(
      peopleCount,
      totalAmount,
      periodStart,
      periodEnd,
    );
  }

  @override
  String toString() {
    return 'AnalysisResult('
        'peopleCount: $peopleCount, '
        'totalAmount: $totalAmount, '
        'periodStart: $periodStart, '
        'periodEnd: $periodEnd'
        ')';
  }

  /// Converts to JSON map
  Map<String, dynamic> toJson() {
    return {
      'peopleCount': peopleCount,
      'totalAmount': totalAmount,
      'periodStart': periodStart,
      'periodEnd': periodEnd,
    };
  }

  /// Creates from JSON map
  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      peopleCount: json['peopleCount'] as int,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      periodStart: json['periodStart'] as String,
      periodEnd: json['periodEnd'] as String,
    );
  }
}
