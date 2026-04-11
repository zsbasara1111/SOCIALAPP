import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案五：私人画廊 (Private Gallery)
///
/// 设计理念：
/// - 走进私人艺术收藏馆的感觉
/// - 大面积的留白，作品是主角
/// - 克制但精致的细节
/// - 每一件"展品"都值得细细品味
///
/// 字体选择逻辑：
/// - 标题：Playfair Display (经典衬线，艺术品标签感)
/// - 正文：Lora (优雅的阅读体验，书籍感)
///
/// 情感目标：高级感、被理解、品味、独特
class PrivateGalleryTheme {
  // 核心色 - 画廊墙白
  static const Color primary = Color(0xFF1A1A1A);
  static const Color primaryLight = Color(0xFF4A4A4A);
  static const Color primaryDark = Color(0xFF0A0A0A);

  // 辅助色 - 画框金
  static const Color accent = Color(0xFFC9A962);
  static const Color accentLight = Color(0xFFE0C88A);

  // 背景 - 画廊墙
  static const Color background = Color(0xFFF8F7F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDECE8);

  // 深色模式 - 夜间画廊
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2A2A2A);

  // 文字色
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF5A5A5A);
  static const Color textTertiary = Color(0xFF9A9A9A);
  static const Color textInverse = Color(0xFFF8F7F5);

  static const Color darkTextPrimary = Color(0xFFF0F0F0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF707070);

  // 功能色
  static const Color success = Color(0xFF5A7D5A);
  static const Color error = Color(0xFF9A5A5A);
  static const Color warning = Color(0xFFB8A05A);
  static const Color info = Color(0xFF5A7A9A);

  // 字体
  static const String fontDisplay = 'Playfair Display';
  static const String fontBody = 'Lora';

  // 间距 - 画廊般的呼吸感
  static const double spaceXs = 8.0;
  static const double spaceSm = 16.0;
  static const double spaceMd = 32.0;
  static const double spaceLg = 64.0;
  static const double spaceXl = 96.0;
  static const double space2Xl = 128.0;

  // 圆角 - 画框感
  static const double radiusSm = 0.0;
  static const double radiusMd = 2.0;
  static const double radiusLg = 4.0;
  static const double radiusXl = 8.0;

  // 阴影 - 微妙的深度
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // 文字样式
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 48,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: -1,
    height: 1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.8,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: accent,
    letterSpacing: 1.5,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: textInverse,
        secondary: accent,
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
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: darkTextPrimary,
        onPrimary: darkBackground,
        secondary: accentLight,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        background: darkBackground,
        onBackground: darkTextPrimary,
        error: error,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: darkTextPrimary),
        displayMedium: displayMedium.copyWith(color: darkTextPrimary),
        titleLarge: titleLarge.copyWith(color: darkTextPrimary),
        bodyLarge: bodyLarge.copyWith(color: darkTextPrimary),
        bodyMedium: bodyMedium.copyWith(color: darkTextSecondary),
        labelLarge: labelLarge.copyWith(color: accentLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
