import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案F: 赛博朋克霓虹
/// 特点: 黑底、霓虹渐变、网格背景、故障效果
class CyberpunkTheme {
  // 颜色系统 - 霓虹赛博朋克
  static const Color background = Color(0xFF050508);
  static const Color surface = Color(0xFF0D0D14);
  static const Color surfaceLight = Color(0xFF161622);
  static const Color neonPink = Color(0xFFFF10F0);
  static const Color neonCyan = Color(0xFF00FFFF);
  static const Color neonPurple = Color(0xFFB829DD);
  static const Color neonYellow = Color(0xFFFFE600);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF808099);

  // 渐变
  static const LinearGradient cyberGradient = LinearGradient(
    colors: [neonPink, neonPurple, neonCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkGradient = LinearGradient(
    colors: [neonPink, neonPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // 间距
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // 圆角 - 锐利几何
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 0; // 方角更有科技感

  // 字体 - 科技感字体
  static const String fontFamily = 'Rajdhani';

  // 霓虹发光
  static List<BoxShadow> get neonPinkShadow => [
    BoxShadow(
      color: neonPink.withOpacity(0.6),
      blurRadius: 15,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: neonPink.withOpacity(0.3),
      blurRadius: 30,
      spreadRadius: 5,
    ),
  ];

  static List<BoxShadow> get neonCyanShadow => [
    BoxShadow(
      color: neonCyan.withOpacity(0.6),
      blurRadius: 15,
      spreadRadius: 2,
    ),
  ];

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: neonPink,
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
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: 2,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonPink,
          foregroundColor: background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: neonCyan,
          side: const BorderSide(color: neonCyan, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
          side: const BorderSide(color: neonPurple, width: 1),
        ),
        margin: const EdgeInsets.all(spaceMd),
      ),
    );
  }
}
