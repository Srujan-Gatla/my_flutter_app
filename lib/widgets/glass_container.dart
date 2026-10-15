import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Border? customBorder;
  final Color? borderColor;
  final double borderWidth;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.08,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.customBorder,
    this.borderColor,
    this.borderWidth = 1.0,
    this.gradient,
    this.shadows,
    this.onTap,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final border = customBorder ??
        Border.all(
          color: borderColor ?? AppColors.glassBorder,
          width: borderWidth,
        );

    final defaultGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: opacity + 0.06),
        Colors.white.withValues(alpha: opacity),
        Colors.white.withValues(alpha: (opacity * 0.4).clamp(0.01, 1.0)),
      ],
      stops: const [0.0, 0.45, 1.0],
    );

    final defaultShadows = shadows ??
        [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 20.0,
            spreadRadius: -2.0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: (borderColor ?? AppColors.primary).withValues(alpha: 0.05),
            blurRadius: 10.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 2),
          ),
        ];

    Widget content = Container(
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient ?? defaultGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: defaultShadows,
      ),
      child: child,
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white.withValues(alpha: 0.12),
          highlightColor: Colors.white.withValues(alpha: 0.06),
          onTap: onTap,
          child: content,
        ),
      );
    }

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      ),
    );
  }
}
