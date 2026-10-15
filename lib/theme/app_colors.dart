import 'package:flutter/material.dart';

class AppColors {
  // Background Colors
  static const Color bgDark = Color(0xFF080C16);
  static const Color bgSurface = Color(0xFF0F172A);
  static const Color bgCard = Color(0xFF1E1E2E);

  // Gradient Background Accents
  static const Color gradientStart = Color(0xFF0B132B);
  static const Color gradientMid = Color(0xFF1C1440);
  static const Color gradientEnd = Color(0xFF080C18);

  // Mesh Orb Glow Accents
  static const Color orbCyan = Color(0xFF00E5FF);
  static const Color orbPurple = Color(0xFF8B5CF6);
  static const Color orbPink = Color(0xFFEC4899);
  static const Color orbBlue = Color(0xFF3B82F6);
  static const Color orbEmerald = Color(0xFF10B981);

  // Primary Theme Accents
  static const Color primary = Color(0xFF8B5CF6); // Vibrant Purple
  static const Color secondary = Color(0xFF00E5FF); // Neon Cyan
  static const Color tertiary = Color(0xFFF43F5E); // Neon Rose
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Glassmorphism Overlay Colors
  static Color glassSurface = Colors.white.withValues(alpha: 0.08);
  static Color glassSurfaceLight = Colors.white.withValues(alpha: 0.14);
  static Color glassSurfaceDark = Colors.black.withValues(alpha: 0.28);
  static Color glassBorder = Colors.white.withValues(alpha: 0.16);
  static Color glassBorderHighlight = Colors.white.withValues(alpha: 0.32);
}
