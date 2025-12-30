import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Privacy information badge
class PrivacyBadge extends StatelessWidget {
  final String privacyText;

  const PrivacyBadge({
    super.key,
    required this.privacyText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock,
          size: AppTheme.iconSmall,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: AppTheme.spaceSmall),
        Flexible(
          child: Text(
            privacyText,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
