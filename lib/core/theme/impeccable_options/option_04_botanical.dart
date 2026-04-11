import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案四：植物园漫步 (Botanical Garden)
///
/// 设计理念：
/// - 走进温室植物园的感觉
/// - 湿润、清新、充满生机
/// - 自然有机的形态
/// - 随性但有生命力
///
/// 字体选择逻辑：
/// - 标题：Cormorant Garamond (优雅的衬线，有机感)
/// - 正文：Nunito (圆润友好，自然亲和)
///
/// 情感目标：自然、随性、生命力、清新
class BotanicalGardenTheme {
  // 核心色 - 植物绿
  static const Color primary = Color(0xFF2D5A4A);
  static const Color primaryLight = Color(0xFF4A7C6F);
  static const Color primaryDark = Color(0xFF1E3D32);

  // 辅助色 - 花朵粉 & 泥土棕
  static const Color secondary = Color(0xFFE8B4B8);
  static const Color accent = Color(0xFFD4A574);

  // 背景 - 温室白绿
  static const Color background = Color(0xFFF5F9F7);
  static const Color surface = Color(0xFFFAFDFC);
  static const Color surfaceVariant = Color(0xFFE8F0ED);

  // 深色模式 - 夜间温室
  static const Color darkBackground = Color(0xFF1A2622);
  static const Color darkSurface = Color(0xFF243832);
  static const Color darkSurfaceVariant = Color(0xFF2E4540);

  // 文字色
  static const Color textPrimary = Color(0xFF1E3D32);
  static const Color textSecondary = Color(0xFF4A6B5F);
  static const Color textTertiary = Color(0xFF8A9B94);
  static const Color textInverse = Color(0xFFFAFDFC);

  static const Color darkTextPrimary = Color(0xFFE8F0ED);
  static const Color darkTextSecondary = Color(0xFFA8B8B0);
  static const Color darkTextTertiary = Color(0xFF687C74);

  // 功能色
  static const Color success = Color(0xFF5D8C6C);
  static const Color error = Color(0xFFD4776A);
  static const Color warning = Color(0xFFE8C547);
  static const Color info = Color(0xFF6B9BC3);

  // 渐变 - 植物生长
  static const LinearGradient leafGradient = LinearGradient(
    colors: [Color(0xFF2D5A4A), Color(0xFF4A7C6F), Color(0xFF6B9E8C)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  // 字体
  static const String fontDisplay = 'Cormorant Garamond';
  static const String fontBody = 'Nunito';

  // 间距 - 有机不规则
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 12.0;
  static const double spaceLg = 20.0;
  static const double spaceXl = 32.0;
  static const double space2Xl = 52.0;

  // 圆角 - 有机曲线
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 28.0;
  static const double radiusXl = 48.0;

  // 阴影 - 柔和光
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A2D5A4A),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x262D5A4A),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // 文字样式
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 42,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.7,
    letterSpacing: 0.2,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
    letterSpacing: 0.15,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: primary,
    letterSpacing: 0.3,
  );

  static ThemeData get lightTheme {
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
        primary: primaryLight,
        onPrimary: textPrimary,
        secondary: secondary,
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
        labelLarge: labelLarge.copyWith(color: primaryLight),
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
