import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.screenBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.headerGradientStart,
      primary: AppColors.headerGradientStart,
      surface: AppColors.screenBg,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.headerGradientStart,
      secondary: AppColors.headerGradientEnd,
    ),
  );
}
