import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ===============================
  // Display
  // ===============================

  static final TextStyle displayLarge = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -1,
  );

  static final TextStyle displayMedium = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ===============================
  // Headings
  // ===============================

  static final TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle heading4 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // ===============================
  // Titles
  // ===============================

  static final TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle titleMedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static final TextStyle titleSmall = GoogleFonts.poppins(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // ===============================
  // Body
  // ===============================

  static final TextStyle bodyLarge = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ===============================
  // Button
  // ===============================

  static final TextStyle buttonLarge = GoogleFonts.poppins(
    fontSize: 17,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle buttonMedium = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // ===============================
  // Caption
  // ===============================

  static final TextStyle caption = GoogleFonts.poppins(
    fontSize: 11,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  // ===============================
  // Service Card
  // ===============================

  static final TextStyle serviceTitle = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static final TextStyle serviceSubtitle = GoogleFonts.poppins(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static final TextStyle servicePrice = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );

  // ===============================
  // Hero Banner
  // ===============================

  static final TextStyle heroTitle = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle heroSubtitle = GoogleFonts.poppins(
    fontSize: 15,
    color: Colors.white70,
    fontWeight: FontWeight.w500,
  );

  // ===============================
  // Order Card
  // ===============================

  static final TextStyle orderNumber = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static final TextStyle orderStatus = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.success,
  );

  // ===============================
  // Rewards
  // ===============================

  static final TextStyle rewardPoint = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.premiumGold,
  );

  static final TextStyle rewardText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // ===============================
  // Bottom Navigation
  // ===============================

  static final TextStyle navLabel = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}