import 'package:flutter/material.dart';

class AppColors {
  static const Color bgTop = Color(0xFF1A0B3B);
  static const Color bgMiddle = Color(0xFF2B1166);
  static const Color bgBottom = Color(0xFF0A1B4A);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color pink = Color(0xFFFF3D9A);
  static const Color orange = Color(0xFFFF9E3D);
  static const Color yellow = Color(0xFFFFD166);
  static const Color cyan = Color(0xFF2DE2E6);
  static const Color mutedText = Color(0xB3FFFFFF);
  static const Color glass = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color pinkGlow = Color(0x55FF3D9A);
  static const Color cyanGlow = Color(0x442DE2E6);

  static const LinearGradient background = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgTop, bgMiddle, bgBottom],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [pink, orange],
  );

  static const LinearGradient coolGradient = LinearGradient(
    colors: [violet, cyan],
  );

  static const LinearGradient clearGradient = LinearGradient(
    colors: [Color(0x00000000), Color(0x00000000)],
  );

  static const LinearGradient doneGradient = LinearGradient(
    colors: [Color(0x3329E2E6), Color(0x338B5CF6)],
  );

  static const LinearGradient dialogGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2B1166), Color(0xFF14234F)],
  );
}

class AppTheme {
  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.violet,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.pink,
      secondary: AppColors.cyan,
      surface: AppColors.bgTop,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgBottom,
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.orange,
        selectionHandleColor: AppColors.orange,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.mutedText),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.bgMiddle,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}