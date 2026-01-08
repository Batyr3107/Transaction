import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

/// Beautiful animated upload button with pulse effect
class UploadButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final String uploadText;
  final String analyzingText;

  const UploadButton({
    super.key,
    required this.isLoading,
    required this.onTap,
    required this.uploadText,
    required this.analyzingText,
  });

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Semantics(
      button: true,
      enabled: !widget.isLoading,
      label: widget.isLoading ? widget.analyzingText : widget.uploadText,
      hint: 'Tap to select PDF file for analysis',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.isLoading ? null : widget.onTap,
          child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulseValue = _pulseController.value;

            return AnimatedContainer(
              duration: AppTheme.durationMedium,
              curve: AppTheme.curveDefault,
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.paddingXL,
                vertical: AppTheme.paddingXXL,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardColor(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(
                    alpha: widget.isLoading ? 0.5 : (_isHovered ? 0.8 : 0.3),
                  ),
                  width: _isHovered ? 2.5 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(
                      alpha: widget.isLoading
                          ? 0.15 + (pulseValue * 0.15)
                          : (_isHovered ? 0.25 : 0.1),
                    ),
                    blurRadius: widget.isLoading
                        ? 20 + (pulseValue * 15)
                        : (_isHovered ? 30 : 15),
                    offset: const Offset(0, 8),
                    spreadRadius: widget.isLoading ? pulseValue * 5 : 0,
                  ),
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon area
                  AnimatedSwitcher(
                    duration: AppTheme.durationMedium,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: widget.isLoading
                        ? _buildLoadingIndicator(isDark)
                        : _buildIcon(isDark),
                  ),

                  const SizedBox(height: AppTheme.spaceLarge),

                  // Text
                  AnimatedSwitcher(
                    duration: AppTheme.durationMedium,
                    child: Text(
                      widget.isLoading ? widget.analyzingText : widget.uploadText,
                      key: ValueKey(widget.isLoading),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textPrimaryColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),

                  if (!widget.isLoading) ...[
                    const SizedBox(height: AppTheme.spaceSmall),
                    Text(
                      'PDF',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryColor(context),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildIcon(bool isDark) {
    return Container(
      key: const ValueKey('icon'),
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
            AppTheme.primaryColor.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.upload_file_rounded,
        size: AppTheme.iconHuge,
        color: AppTheme.primaryColor,
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2000.ms,
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
        );
  }

  Widget _buildLoadingIndicator(bool isDark) {
    return Container(
      key: const ValueKey('loading'),
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: SizedBox(
        width: AppTheme.iconHuge,
        height: AppTheme.iconHuge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            SizedBox(
              width: AppTheme.iconHuge,
              height: AppTheme.iconHuge,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            // Inner ring
            SizedBox(
              width: AppTheme.iconXXL,
              height: AppTheme.iconXXL,
              child: const CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              ),
            ),
            // Center icon
            Icon(
              Icons.analytics_outlined,
              size: AppTheme.iconLarge,
              color: AppTheme.primaryColor,
            )
                .animate(onPlay: (c) => c.repeat())
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 800.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 800.ms,
                  curve: Curves.easeInOut,
                ),
          ],
        ),
      ),
    );
  }
}

/// Compact upload button for secondary actions
class UploadButtonCompact extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final String text;

  const UploadButtonCompact({
    super.key,
    required this.isLoading,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onTap,
      icon: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )
          : const Icon(Icons.upload_file_rounded),
      label: Text(text),
    );
  }
}
