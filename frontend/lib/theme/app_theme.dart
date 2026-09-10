import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  /// design_files/App_Design.html에서 추출한 커스텀 폰트("LB KR"/"LB SC") —
  /// pubspec.yaml에 이 이름으로 등록돼 있다. LB SC는 중국어 글리프,
  /// NotoSansKR/NotoSans는 LB KR이 못 그리는 글자(베트남어 발음부호 등)의
  /// 폴백이다 — fontFamily를 명시하지 않은 모든 TextStyle에 기본 상속된다.
  static const _fontFamily = 'LB KR';
  static const _fontFamilyFallback = ['LB SC', 'NotoSansKR', 'NotoSans'];

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      fontFamilyFallback: _fontFamilyFallback,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.blue50,
        onPrimaryContainer: AppColors.blue900,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.green50,
        onSecondaryContainer: AppColors.green900,
        tertiary: AppColors.accent,
        onTertiary: AppColors.blue900,
        tertiaryContainer: AppColors.blue50,
        onTertiaryContainer: AppColors.blue900,
        error: AppColors.blue900,
        onError: Colors.white,
        errorContainer: AppColors.blue50,
        onErrorContainer: AppColors.blue900,
        surface: Colors.white,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.blue200,
        outlineVariant: AppColors.blue50,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      // 화면이 자체 style:을 지정한 버튼(대부분)엔 영향이 없고, 지정하지 않은
      // 버튼만 이 기본값(시안 .btn/.btn.outline 스펙)을 따른다.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          // 흰 배경이 아니라 투명 배경이 기본값이어야 한다 — 화면이 색 있는
          // 카드 위에 foregroundColor만 흰색으로 바꿔 버튼을 올리는 경우
          // (예: 파란 그라데이션 카드), backgroundColor를 흰색으로 깔면
          // 흰 글자가 흰 배경에 묻혀 안 보이게 된다. 투명이면 어떤 배경
          // 위에 놓여도 항상 그 배경이 그대로 비쳐서 안전하다 — 흰 배경
          // 화면에서는 투명이든 흰색이든 어차피 똑같이 보인다.
          backgroundColor: Colors.transparent,
          side: const BorderSide(color: AppColors.border),
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
