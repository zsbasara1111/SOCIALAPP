import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案H：轻奢莫兰迪
///
/// 设计理念：
/// - 低饱和度莫兰迪色系
/// - 高级灰色调
/// - 优雅柔和的氛围
/// - 精致而不张扬
class MorandiTheme {
  // 主色调 - 莫兰迪粉
  static const Color primary = Color(0xFFB5838D);
  static const Color primaryLight = Color(0xFFC99AA3);
  static const Color primaryDark = Color(0xFF9A6B75);

  // 辅色 - 莫兰迪绿
  static const Color secondary = Color(0xFF8A9A8C);
  static const Color accent = Color(0xFFE6CCB2);

  // 背景色 - 暖灰白
  static const Color background = Color(0xFFF5F0EB);
  static const Color surface = Color(0xFFFAF7F4);
  static const Color surfaceVariant = Color(0xFFE8E2DC);

  // 文字色 - 高级灰
  static const Color textPrimary = Color(0xFF4A4A4A);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color textTertiary = Color(0xFFA8A8A8);
  static const Color textInverse = Color(0xFFFAF7F4);

  // 功能色
  static const Color success = Color(0xFF8B9D83);
  static const Color error = Color(0xFFC97B7B);
  static const Color warning = Color(0xFFD4A574);
  static const Color info = Color(0xFF7B9DC9);

  // 圆角 - 优雅柔和
  static const double radiusSm = 6.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;

  // 阴影 - 柔和高级
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A5C4A4A),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x265C4A4A),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x335C4A4A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // 字体 - 优雅衬线
  static const String fontFamily = 'Playfair Display';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.7,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
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
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
    );
  }
}
