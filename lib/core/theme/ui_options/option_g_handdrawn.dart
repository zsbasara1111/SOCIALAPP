import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案G：手绘插画风
///
/// 设计理念：
/// - 温暖米色背景
/// - 手绘线条感
/// - 柔和不规则形状
/// - 亲切可爱的配色
class HandDrawnTheme {
  // 主色调 - 温暖橙
  static const Color primary = Color(0xFFFF8C42);
  static const Color primaryLight = Color(0xFFFFB366);
  static const Color primaryDark = Color(0xFFE67A32);

  // 辅色 - 清新绿
  static const Color secondary = Color(0xFF7CB342);
  static const Color accent = Color(0xFFFFD54F);

  // 背景色 - 温暖米
  static const Color background = Color(0xFFFDF6E3);
  static const Color surface = Color(0xFFFFF8E7);
  static const Color surfaceVariant = Color(0xFFF5ECD0);

  // 文字色 - 温暖灰
  static const Color textPrimary = Color(0xFF3D3D3D);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textInverse = Color(0xFFFFF8E7);

  // 功能色
  static const Color success = Color(0xFF8BC34A);
  static const Color error = Color(0xFFFF7043);
  static const Color warning = Color(0xFFFFCA28);
  static const Color info = Color(0xFF42A5F5);

  // 圆角 - 圆润可爱
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;

  // 阴影 - 柔和
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A5D4037),
      blurRadius: 4,
      offset: Offset(2, 3),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x265D4037),
      blurRadius: 8,
      offset: Offset(3, 5),
    ),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x335D4037),
      blurRadius: 16,
      offset: Offset(4, 8),
    ),
  ];

  // 字体 - 圆润手写
  static const String fontFamily = 'Quicksand';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: primary,
    letterSpacing: 0.5,
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: textInverse,
        secondary: secondary,
        surface: surface,
        onSurface: textPrimary,
        background: background,
        onBackground: textPrimary,
        error: error,
      ),
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        titleLarge: titleLarge,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: labelLarge,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textInverse,
          elevation: 3,
          shadowColor: const Color(0x405D4037),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 3,
        shadowColor: const Color(0x405D4037),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
    );
  }
}
