import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案I：复古胶片风
///
/// 设计理念：
/// - 胶片质感暖色调
/// - 颗粒感纹理
/// - 怀旧复古配色
/// - 经典电影感
class RetroFilmTheme {
  // 主色调 - 胶片棕
  static const Color primary = Color(0xFF8B6914);
  static const Color primaryLight = Color(0xFFA67C2E);
  static const Color primaryDark = Color(0xFF6B520F);

  // 辅色 - 复古红
  static const Color secondary = Color(0xFFC75B39);
  static const Color accent = Color(0xFFD4A853);

  // 背景色 - 米色胶片
  static const Color background = Color(0xFFE8DCC4);
  static const Color surface = Color(0xFFF0E6D3);
  static const Color surfaceVariant = Color(0xFFD4C4A8);

  // 文字色 - 深褐
  static const Color textPrimary = Color(0xFF3D2914);
  static const Color textSecondary = Color(0xFF6B5235);
  static const Color textTertiary = Color(0xFF9A8566);
  static const Color textInverse = Color(0xFFF0E6D3);

  // 功能色
  static const Color success = Color(0xFF6B8E5E);
  static const Color error = Color(0xFFB85450);
  static const Color warning = Color(0xFFD4A853);
  static const Color info = Color(0xFF5E7B8E);

  // 圆角 - 复古方角
  static const double radiusSm = 2.0;
  static const double radiusMd = 4.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 12.0;

  // 阴影 - 暖色
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x266B520F),
      blurRadius: 4,
      offset: Offset(1, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x406B520F),
      blurRadius: 8,
      offset: Offset(2, 4),
    ),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x596B520F),
      blurRadius: 16,
      offset: Offset(3, 6),
    ),
  ];

  // 字体 - 复古衬线
  static const String fontFamily = 'Libre Baskerville';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.2,
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
    fontWeight: FontWeight.w600,
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
          shadowColor: const Color(0x406B520F),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSm),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 3,
        shadowColor: const Color(0x406B520F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: Color(0xFFD4C4A8), width: 1),
        ),
      ),
    );
  }
}
