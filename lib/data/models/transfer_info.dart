import 'package:flutter/foundation.dart';

/// Represents information about a single transfer
@immutable
class TransferInfo {
  /// Recipient name or identifier
  final String recipient;

  /// Transfer amount (absolute value)
  final double amount;

  const TransferInfo({
    required this.recipient,
    required this.amount,
  });

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
