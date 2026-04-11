import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案D: 新中式典雅
/// 特点: 宣纸色、墨黑、中式元素、印章效果
class ChineseElegantTheme {
  // 颜色系统 - 传统中式色彩
  static const Color background = Color(0xFFF5F0E8); // 宣纸色
  static const Color surface = Color(0xFFFDFBF7); // 米白
  static const Color primary = Color(0xFF8B1A1A); // 朱砂红
  static const Color secondary = Color(0xFF2F4F4F); // 墨绿
  static const Color gold = Color(0xFFB8860B); // 金
  static const Color textPrimary = Color(0xFF1A1A1A); // 墨黑
  static const Color textSecondary = Color(0xFF666666);
  static const Color border = Color(0xFFD4C8B8); // 枯墨

  // 间距
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // 圆角 - 含蓄内敛
  static const double radiusSm = 2;
  static const double radiusMd = 4;
  static const double radiusLg = 8;

  // 字体 - 宋体风格
  static const String fontFamily = 'Songti SC';
  static const String fontFamilyDisplay = 'Kaiti SC';

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        surface: surface,
        onSurface: textPrimary,
        background: background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamilyDisplay,
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: border, width: 0.5),
        ),
        margin: const EdgeInsets.all(spaceMd),
      ),
    );
  }
}
