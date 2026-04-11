import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案D：新中式典雅
///
/// 设计理念：
/// - 宣纸米黄底色
/// - 朱砂红、墨黑点缀
/// - 宋体/书法字体
/// - 山水意境
class ChineseElegantTheme {
  // 主色调 - 朱砂红
  static const Color primary = Color(0xFFC73E3A);
  static const Color primaryLight = Color(0xFFE85D5A);
  static const Color primaryDark = Color(0xFFA0302D);

  // 辅色 - 墨青
  static const Color secondary = Color(0xFF2F4F4F);
  static const Color accent = Color(0xFFD4AF37); // 金色

  // 背景色 - 宣纸色系
  static const Color background = Color(0xFFFAF5E6);
  static const Color surface = Color(0xFFFDF8EA);
  static const Color surfaceVariant = Color(0xFFF5ECD8);

  // 文字色 - 墨色
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textTertiary = Color(0xFF8A8A8A);
  static const Color textInverse = Color(0xFFFDF8EA);

  // 功能色
  static const Color success = Color(0xFF4A7C59);
  static const Color error = Color(0xFFC73E3A);
  static const Color warning = Color(0xFFD4AF37);
  static const Color info = Color(0xFF2F4F4F);

  // 圆角 - 含蓄内敛
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;

  // 阴影 - 水墨晕染感
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(2, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(3, 3),
    ),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 16,
      offset: Offset(4, 4),
    ),
  ];

  // 字体 - 中式宋体
  static const String fontFamily = 'Noto Serif SC';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 2.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 1.5,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 1.0,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: 0.5,
    height: 1.8,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    letterSpacing: 0.3,
    height: 1.6,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primary,
    letterSpacing: 0.8,
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
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          side: const BorderSide(color: Color(0xFFE0D5C5), width: 1),
        ),
      ),
    );
  }
}
