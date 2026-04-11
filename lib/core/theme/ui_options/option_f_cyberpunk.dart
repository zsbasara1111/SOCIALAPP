import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案F：赛博朋克霓虹
///
/// 设计理念：
/// - 深紫/黑背景
/// - 霓虹粉紫渐变
/// - 故障艺术效果
/// - 未来都市感
class CyberpunkTheme {
  // 主色调 - 霓虹粉
  static const Color primary = Color(0xFFFF00FF);
  static const Color primaryLight = Color(0xFFFF66FF);
  static const Color primaryDark = Color(0xFFCC00CC);

  // 辅色 - 电光青
  static const Color secondary = Color(0xFF00FFFF);
  static const Color accent = Color(0xFF9900FF);

  // 背景色 - 深紫黑
  static const Color background = Color(0xFF0D001A);
  static const Color surface = Color(0xFF1A0033);
  static const Color surfaceVariant = Color(0xFF2D0052);

  // 文字色 - 霓虹白
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFE0E0FF);
  static const Color textTertiary = Color(0xFF8080A0);
  static const Color textInverse = Color(0xFF0D001A);

  // 功能色
  static const Color success = Color(0xFF00FF99);
  static const Color error = Color(0xFFFF0055);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF00CCFF);

  // 渐变色 - 赛博朋克风格
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF00FF), Color(0xFF00FFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [Color(0xFFFF00FF), Color(0xFF9900FF), Color(0xFF00FFFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // 圆角 - 锐利
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;

  // 阴影 - 霓虹发光
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x80FF00FF),
      blurRadius: 10,
      offset: Offset(0, 0),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0xB3FF00FF),
      blurRadius: 20,
      offset: Offset(0, 0),
    ),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0xCC00FFFF),
      blurRadius: 40,
      offset: Offset(0, 0),
    ),
  ];

  // 字体 - 未来科技
  static const String fontFamily = 'Orbitron';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
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
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: primary,
    letterSpacing: 1.0,
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
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
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textInverse,
          elevation: 0,
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
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}
