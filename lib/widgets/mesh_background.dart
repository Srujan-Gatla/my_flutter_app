import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MeshBackground extends StatelessWidget {
  final Widget child;

  const MeshBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Base dark gradient background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.bgDark,
                AppColors.gradientStart,
                AppColors.gradientMid,
                AppColors.gradientEnd,
              ],
              stops: [0.0, 0.35, 0.75, 1.0],
            ),
          ),
        ),

        // Glowing Ambient Orb 1 - Top Left (Vibrant Violet / Indigo)
        Positioned(
          top: -size.height * 0.1,
          left: -size.width * 0.25,
          child: Container(
            width: size.width * 0.85,
            height: size.width * 0.85,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.orbPurple.withValues(alpha: 0.35),
                  AppColors.orbPurple.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb 2 - Top Right (Neon Cyan)
        Positioned(
          top: size.height * 0.12,
          right: -size.width * 0.3,
          child: Container(
            width: size.width * 0.75,
            height: size.width * 0.75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.orbCyan.withValues(alpha: 0.28),
                  AppColors.orbCyan.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb 3 - Middle Left (Pink / Magenta)
        Positioned(
          top: size.height * 0.48,
          left: -size.width * 0.35,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.orbPink.withValues(alpha: 0.22),
                  AppColors.orbPink.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // Glowing Ambient Orb 4 - Bottom Right (Deep Blue / Teal)
        Positioned(
          bottom: -size.height * 0.05,
          right: -size.width * 0.2,
          child: Container(
            width: size.width * 0.9,
            height: size.width * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.orbBlue.withValues(alpha: 0.30),
                  AppColors.orbEmerald.withValues(alpha: 0.10),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),

        // Foreground content
        Positioned.fill(child: child),
      ],
    );
  }
}
