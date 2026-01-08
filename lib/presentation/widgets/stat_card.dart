import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

/// Beautiful animated stat card with gradient and glow effects
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final LinearGradient? gradient;
  final VoidCallback? onTap;
  final int animationDelay;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.gradient,
    this.onTap,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final effectiveGradient = gradient ??
        LinearGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.2 : 0.15),
            color.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Semantics(
      label: '$label: $value',
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
        duration: AppTheme.durationMedium,
        curve: AppTheme.curveDefault,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          border: Border.all(
            color: color.withValues(alpha: isDark ? 0.3 : 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isDark ? 0.2 : 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decoration
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                icon,
                size: 120,
                color: color.withValues(alpha: isDark ? 0.08 : 0.06),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDark ? 0.2 : 0.15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Icon(
                      icon,
                      size: AppTheme.iconLarge,
                      color: color,
                    ),
                  ),

                  const SizedBox(height: AppTheme.spaceMedium),

                  // Value with animated counter effect
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimaryColor(context),
                          letterSpacing: -1,
                        ),
                  ),

                  const SizedBox(height: AppTheme.spaceXS),

                  // Label
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    )
        .animate(delay: Duration(milliseconds: animationDelay))
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.3, end: 0, duration: 500.ms, curve: Curves.easeOutCubic)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 400.ms);
  }
}

/// Horizontal stat card for compact display
class StatCardCompact extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final int animationDelay;

  const StatCardCompact({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow(context),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Icon(
              icon,
              size: AppTheme.iconMedium,
              color: color,
            ),
          ),
          const SizedBox(width: AppTheme.spaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimaryColor(context),
                      ),
                ),
                Text(
                  label,
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
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOutCubic);
  }
}

/// Large stat display for featured stats
class StatCardLarge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final String? subtitle;
  final LinearGradient gradient;
  final VoidCallback? onTap;
  final int animationDelay;

  const StatCardLarge({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.gradient,
    this.subtitle,
    this.onTap,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.paddingXL),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.4),
              blurRadius: 25,
              offset: const Offset(0, 12),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingLarge),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: AppTheme.iconXXL,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: AppTheme.spaceLarge),

            // Value
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTheme.spaceSmall),

            // Label
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spaceXS),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: animationDelay))
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.4, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), duration: 500.ms);
  }
}
