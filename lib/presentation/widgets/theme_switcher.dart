import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/services/theme_service.dart';
import '../../core/theme/app_theme.dart';

/// Beautiful animated theme switcher button
class ThemeSwitcher extends StatelessWidget {
  final ThemeService themeService;

  const ThemeSwitcher({
    super.key,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return GestureDetector(
      onTap: () => themeService.toggleTheme(),
      child: AnimatedContainer(
        duration: AppTheme.durationMedium,
        curve: AppTheme.curveDefault,
        padding: const EdgeInsets.all(AppTheme.paddingSmall),
        decoration: BoxDecoration(
          color: isDark
              ? AppTheme.darkCard
              : AppTheme.lightCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: Border.all(
            color: isDark
                ? AppTheme.darkDivider
                : AppTheme.lightDivider,
            width: 1,
          ),
          boxShadow: AppTheme.cardShadow(context),
        ),
        child: AnimatedSwitcher(
          duration: AppTheme.durationMedium,
          transitionBuilder: (child, animation) {
            return RotationTransition(
              turns: Tween(begin: 0.5, end: 1.0).animate(animation),
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            key: ValueKey(isDark),
            size: AppTheme.iconMedium,
            color: isDark
                ? AppTheme.accentGold
                : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}

/// Theme switcher with label
class ThemeSwitcherWithLabel extends StatelessWidget {
  final ThemeService themeService;
  final String lightLabel;
  final String darkLabel;

  const ThemeSwitcherWithLabel({
    super.key,
    required this.themeService,
    required this.lightLabel,
    required this.darkLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return GestureDetector(
      onTap: () => themeService.toggleTheme(),
      child: AnimatedContainer(
        duration: AppTheme.durationMedium,
        curve: AppTheme.curveDefault,
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.paddingMedium,
          vertical: AppTheme.paddingSmall,
        ),
        decoration: BoxDecoration(
          color: AppTheme.cardColor(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          border: Border.all(
            color: isDark
                ? AppTheme.darkDivider
                : AppTheme.lightDivider,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: AppTheme.durationMedium,
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                key: ValueKey(isDark),
                size: AppTheme.iconSmall,
                color: isDark
                    ? AppTheme.accentGold
                    : AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: AppTheme.spaceSmall),
            AnimatedSwitcher(
              duration: AppTheme.durationMedium,
              child: Text(
                isDark ? darkLabel : lightLabel,
                key: ValueKey(isDark),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondaryColor(context),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Animated sun/moon toggle
class ThemeToggle extends StatelessWidget {
  final ThemeService themeService;

  const ThemeToggle({
    super.key,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return GestureDetector(
      onTap: () => themeService.toggleTheme(),
      child: Container(
        width: 60,
        height: 32,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF87CEEB), Color(0xFFFFE4B5)],
                ),
        ),
        child: Stack(
          children: [
            // Stars (visible in dark mode)
            if (isDark) ...[
              Positioned(
                left: 8,
                top: 5,
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ),
              Positioned(
                left: 15,
                top: 15,
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              ),
              Positioned(
                left: 5,
                bottom: 8,
                child: Container(
                  width: 2,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Colors.white60,
                    shape: BoxShape.circle,
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
              ),
            ],

            // Toggle circle
            AnimatedAlign(
              duration: AppTheme.durationMedium,
              curve: AppTheme.curveSnappy,
              alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFFF5F3CE) : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isDark
                    ? Icon(
                        Icons.nightlight_round,
                        size: 16,
                        color: Colors.grey.shade700,
                      )
                    : Icon(
                        Icons.wb_sunny_rounded,
                        size: 16,
                        color: Colors.orange.shade400,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
