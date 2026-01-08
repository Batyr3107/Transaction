import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

/// Beautiful animated privacy badge with shield icon
class PrivacyBadge extends StatelessWidget {
  final String privacyText;
  final int animationDelay;

  const PrivacyBadge({
    super.key,
    required this.privacyText,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.paddingMedium,
        vertical: AppTheme.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: isDark ? 0.3 : 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_rounded,
              size: AppTheme.iconSmall,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: AppTheme.spaceSmall),
          Flexible(
            child: Text(
              privacyText,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animationDelay))
        .fadeIn(duration: 500.ms, delay: 400.ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 400.ms);
  }
}

/// Expanded privacy badge with more details
class PrivacyBadgeExpanded extends StatelessWidget {
  final String title;
  final String description;
  final int animationDelay;

  const PrivacyBadgeExpanded({
    super.key,
    required this.title,
    required this.description,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successColor.withValues(alpha: isDark ? 0.15 : 0.1),
            AppTheme.successColor.withValues(alpha: isDark ? 0.08 : 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: AppTheme.successColor.withValues(alpha: isDark ? 0.3 : 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              Icons.verified_user_rounded,
              size: AppTheme.iconLarge,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppTheme.spaceXS),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor(context),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animationDelay))
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.1, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}
