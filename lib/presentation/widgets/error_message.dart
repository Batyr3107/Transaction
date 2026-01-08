import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

/// Beautiful animated error message with shake effect
class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final int animationDelay;

  const ErrorMessage({
    super.key,
    required this.message,
    this.onDismiss,
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
            AppTheme.errorColor.withValues(alpha: isDark ? 0.2 : 0.15),
            AppTheme.errorColor.withValues(alpha: isDark ? 0.1 : 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.errorColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: AppTheme.errorColor.withValues(alpha: isDark ? 0.3 : 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: AppTheme.iconMedium,
              color: AppTheme.errorColor,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppTheme.errorLight : AppTheme.errorColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close_rounded,
                size: AppTheme.iconSmall,
                color: AppTheme.errorColor.withValues(alpha: 0.7),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animationDelay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0, duration: 400.ms, curve: Curves.easeOutCubic)
        .shake(hz: 3, rotation: 0.02, duration: 500.ms, delay: 200.ms);
  }
}

/// Success message widget
class SuccessMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final int animationDelay;

  const SuccessMessage({
    super.key,
    required this.message,
    this.onDismiss,
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
            AppTheme.successColor.withValues(alpha: isDark ? 0.2 : 0.15),
            AppTheme.successColor.withValues(alpha: isDark ? 0.1 : 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.successColor.withValues(alpha: 0.3),
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
              Icons.check_circle_outline_rounded,
              size: AppTheme.iconMedium,
              color: AppTheme.successColor,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppTheme.successLight : AppTheme.successColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close_rounded,
                size: AppTheme.iconSmall,
                color: AppTheme.successColor.withValues(alpha: 0.7),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animationDelay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}

/// Warning message widget
class WarningMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final int animationDelay;

  const WarningMessage({
    super.key,
    required this.message,
    this.onDismiss,
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
            AppTheme.warningColor.withValues(alpha: isDark ? 0.2 : 0.15),
            AppTheme.warningColor.withValues(alpha: isDark ? 0.1 : 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.warningColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: AppTheme.warningColor.withValues(alpha: isDark ? 0.3 : 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              size: AppTheme.iconMedium,
              color: AppTheme.warningColor,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppTheme.warningLight : AppTheme.warningDark,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(
                Icons.close_rounded,
                size: AppTheme.iconSmall,
                color: AppTheme.warningColor.withValues(alpha: 0.7),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: animationDelay))
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}
