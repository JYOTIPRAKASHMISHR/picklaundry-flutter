import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===============================
  // Primary Brand Colors
  // ===============================

  static const Color primary = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF7C3AED);
  static const Color accent = Color(0xFF10B981);

  // ===============================
  // Background Colors
  // ===============================

  static const Color background = Color(0xFFF8FAFC);

  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color darkBackground = Color(0xFF0F172A);

  static const Color glass = Color(0xCCFFFFFF);

  // ===============================
  // Text Colors
  // ===============================

  static const Color textPrimary = Color(0xFF0F172A);

  static const Color textSecondary = Color(0xFF64748B);

  static const Color textLight = Color(0xFFFFFFFF);

  // ===============================
  // Status Colors
  // ===============================

  static const Color success = Color(0xFF22C55E);

  static const Color warning = Color(0xFFF59E0B);

  static const Color error = Color(0xFFEF4444);

  static const Color info = Color(0xFF0EA5E9);

  // ===============================
  // Border & Divider
  // ===============================

  static const Color border = Color(0xFFE2E8F0);

  static const Color divider = Color(0xFFF1F5F9);

  // ===============================
  // Laundry Theme Colors
  // ===============================

  static const Color washBlue = Color(0xFF3B82F6);

  static const Color ironOrange = Color(0xFFF97316);

  static const Color dryCleanPurple = Color(0xFF8B5CF6);

  static const Color premiumGold = Color(0xFFFACC15);

  static const Color shoeGreen = Color(0xFF22C55E);

  // ===============================
  // Gradient Colors
  // ===============================

  static const List<Color> primaryGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];

  static const List<Color> purpleGradient = [
    Color(0xFF7C3AED),
    Color(0xFFA855F7),
  ];

  static const List<Color> greenGradient = [
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];

  static const List<Color> orangeGradient = [
    Color(0xFFF97316),
    Color(0xFFFB923C),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFFACC15),
    Color(0xFFF59E0B),
  ];

  static const List<Color> premiumBackground = [
    Color(0xFFF8FAFC),
    Color(0xFFEFF6FF),
    Color(0xFFFFFFFF),
  ];

  // ===============================
  // Hero Banner Gradient
  // ===============================

  static const List<Color> heroGradient = [
    Color(0xFF2563EB),
    Color(0xFF7C3AED),
    Color(0xFF3B82F6),
  ];

  // ===============================
  // Rewards Gradient
  // ===============================

  static const List<Color> rewardGradient = [
    Color(0xFFFACC15),
    Color(0xFFF59E0B),
  ];

  // ===============================
  // Glass Shadow
  // ===============================

  static List<BoxShadow> glassShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 30,
      spreadRadius: 5,
      offset: const Offset(0, 15),
    ),
  ];

  // ===============================
  // Card Shadow
  // ===============================

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 18,
      spreadRadius: 2,
      offset: const Offset(0, 8),
    ),
  ];
}