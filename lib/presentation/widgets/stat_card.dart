import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Displays a statistic with icon, value, and label
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.paddingExtraLarge),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: AppTheme.iconLarge,
            color: color,
          ),
          const SizedBox(height: AppTheme.spaceMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: AppTheme.spaceSmall),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
