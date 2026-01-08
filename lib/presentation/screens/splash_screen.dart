import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

/// Beautiful animated splash screen
class SplashScreen extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  const SplashScreen({
    super.key,
    required this.onAnimationComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      widget.onAnimationComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppTheme.darkBackground, AppTheme.darkSurface]
                : [AppTheme.lightBackground, AppTheme.lightSurface],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background decorative elements
            ..._buildBackgroundElements(isDark),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container
                  _buildLogo(isDark),

                  const SizedBox(height: AppTheme.spaceXL),

                  // App name
                  _buildAppName(context),

                  const SizedBox(height: AppTheme.spaceSmall),

                  // Tagline
                  _buildTagline(context),

                  const SizedBox(height: AppTheme.spaceHuge),

                  // Loading indicator
                  _buildLoadingIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBackgroundElements(bool isDark) {
    return [
      // Top right circle
      Positioned(
        top: -100,
        right: -100,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.primaryColor.withValues(alpha: isDark ? 0.15 : 0.1),
                AppTheme.primaryColor.withValues(alpha: 0),
              ],
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              duration: 1000.ms,
              curve: Curves.easeOutCubic,
            )
            .fadeIn(duration: 800.ms),
      ),

      // Bottom left circle
      Positioned(
        bottom: -150,
        left: -150,
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.infoColor.withValues(alpha: isDark ? 0.1 : 0.08),
                AppTheme.infoColor.withValues(alpha: 0),
              ],
            ),
          ),
        )
            .animate()
            .scale(
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              duration: 1200.ms,
              delay: 200.ms,
              curve: Curves.easeOutCubic,
            )
            .fadeIn(duration: 800.ms),
      ),
    ];
  }

  Widget _buildLogo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingXL),
      decoration: BoxDecoration(
        gradient: AppTheme.kaspiGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.4),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: const Icon(
        Icons.analytics_rounded,
        size: AppTheme.iconMassive,
        color: Colors.white,
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 600.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 400.ms)
        .then(delay: 200.ms)
        .shimmer(
          duration: 1500.ms,
          color: Colors.white.withValues(alpha: 0.3),
        );
  }

  Widget _buildAppName(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => AppTheme.kaspiGradient.createShader(bounds),
      child: Text(
        'Kaspi Analyzer',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -1,
            ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 600.ms,
          delay: 400.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildTagline(BuildContext context) {
    return Text(
      'Smart Financial Insights',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppTheme.textSecondaryColor(context),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 600.ms)
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 600.ms,
          delay: 600.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          AppTheme.primaryColor.withValues(alpha: 0.7),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 1000.ms)
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: 1000.ms,
        );
  }
}
