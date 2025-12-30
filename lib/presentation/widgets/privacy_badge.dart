import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_strings.dart';

/// Privacy information badge
class PrivacyBadge extends StatelessWidget {
  const PrivacyBadge({super.key});

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
        Text(
          AppStrings.privacyMessage,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
