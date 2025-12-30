import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_strings.dart';

/// Upload button widget for PDF file selection
class UploadButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const UploadButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: AppTheme.elevationLow,
      borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingExtraLarge,
            vertical: 50,
          ),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: AppTheme.uploadBorder,
          ),
          child: Column(
            children: [
              if (isLoading)
                const CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                )
              else
                const Icon(
                  Icons.description,
                  size: AppTheme.iconExtraLarge,
                  color: AppTheme.primaryColor,
                ),
              const SizedBox(height: AppTheme.spaceLarge),
              Text(
                isLoading ? AppStrings.analyzing : AppStrings.uploadButton,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
