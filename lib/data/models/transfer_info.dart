import 'package:flutter/foundation.dart';

/// Represents information about a single transfer
@immutable
class TransferInfo {
  /// Recipient name or identifier
  final String recipient;

  /// Transfer amount (absolute value)
  final double amount;

  /// Creates a TransferInfo with validation
  ///
  /// Throws [AssertionError] if:
  /// - recipient is empty or whitespace-only
  /// - amount is negative, NaN, or infinite
  const TransferInfo({
    required this.recipient,
    required this.amount,
  })  : assert(recipient != '', 'Recipient cannot be empty'),
        assert(amount >= 0, 'Amount must be non-negative'),
        assert(amount != double.nan, 'Amount cannot be NaN'),
        assert(amount != double.infinity, 'Amount cannot be infinite'),
        assert(amount != double.negativeInfinity, 'Amount cannot be negative infinity');

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransferInfo &&
        other.recipient == recipient &&
        other.amount == amount;
  }

  @override
  int get hashCode => Object.hash(recipient, amount);

  @override
  String toString() {
    return 'TransferInfo(recipient: $recipient, amount: $amount)';
  }
}
