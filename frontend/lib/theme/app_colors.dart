import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Blue palette supplied for the project.
  static const blue50 = Color(0xFFE3F2FD);
  static const blue200 = Color(0xFF90CAF9);
  static const blue500 = Color(0xFF2196F3);
  static const blue900 = Color(0xFF0D47A1);

  // Material green companions used for positive and completed states.
  static const green50 = Color(0xFFE8F5E9);
  static const green200 = Color(0xFFA5D6A7);
  static const green500 = Color(0xFF4CAF50);
  static const green900 = Color(0xFF1B5E20);

  static const primary = blue500;
  static const secondary = green500;
  static const accent = blue200;
  static const background = blue50;
  static const navy = blue900;

  // Neutral colors remain for readable text and white content surfaces.
  static const textPrimary = Color(0xFF1E293B);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted = Color(0xFF94A3B8);
  static const border = blue200;

  static const noticeBg = blue50;
  static const noticeBorder = blue200;
  static const noticeText = blue900;
  static const blueBg = blue50;
  static const blueBorder = blue200;
}
