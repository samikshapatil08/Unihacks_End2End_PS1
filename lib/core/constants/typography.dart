import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colours.dart';

class AppTypography {
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryText,
  );

  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryText,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryText,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryText,
  );
}