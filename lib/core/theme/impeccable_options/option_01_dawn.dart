import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案一：晨曦微光 (Dawn Glow)
///
/// 设计理念：
/// - 日出时分的温暖色调，象征新的开始和期待
/// - 温柔的金橘渐变，给人希望和活力
/// - 如同清晨第一缕阳光，温暖而不刺眼
/// - 唤醒对美好相遇的期待
///
/// 字体选择逻辑：
/// - 标题：Raleway (优雅现代，有独特的w字形)
/// - 正文：Cabin (清晰可读，略带人文感)
/// 避开：Inter, DM Sans, Poppins等AI常用字体
///
/// 情感目标：期待感、温暖、希望
class DawnGlowTheme {
  // 核心色 - 日出金橘
  static const Color primary = Color(0xFFFF8C61);  // 珊瑚橘
  static const Color primaryLight = Color(0xFFFFB997);
  static const Color primaryDark = Color(0xFFE87A4F);

  // 辅助色 - 晨曦天空
  static const Color secondary = Color(0xFF87CEEB);  // 天蓝
  static const Color accent = Color(0xFFFFD700);     // 朝阳金

  // 背景 - 破晓时分
  static const Color background = Color(0xFFFFF8F3);  // 暖白
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF0E8);

  // 深色模式 - 深夜到黎明
  static const Color darkBackground = Color(0xFF1A1625);  // 深紫灰
  static const Color darkSurface = Color(0xFF252236);
  static const Color darkSurfaceVariant = Color(0xFF302D42);

  // 文字色
  static const Color textPrimary = Color(0xFF2D2420);      // 深暖棕
  static const Color textSecondary = Color(0xFF6B5B54);
  static const Color textTertiary = Color(0xFFA89B94);
  static const Color textInverse = Color(0xFFFFFFFF);

  static const Color darkTextPrimary = Color(0xFFF5F0ED);
  static const Color darkTextSecondary = Color(0xFFB8B0A8);
  static const Color darkTextTertiary = Color(0xFF7A726B);

  // 功能色
  static const Color success = Color(0xFF7CB342);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);

  // 渐变 - 日出天空
  static const LinearGradient dawnGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFD93D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 字体
  static const String fontDisplay = 'Raleway';
  static const String fontBody = 'Cabin';

  // 间距系统 - 黄金比例
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 13.0;  // 非整数，更有机
  static const double spaceLg = 21.0;
  static const double spaceXl = 34.0;
  static const double space2Xl = 55.0;

  // 圆角 - 柔和有机
  static const double radiusSm = 6.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 32.0;

  // 阴影 - 柔和晨曦光
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1AFF8C61),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x26FF8C61),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x33FF8C61),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
  ];

  // 文字样式
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 40,
    fontWeight: FontWeight.w300,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 28,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.6,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
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
      elevatedButtonTheme: ElevatedButton.themeFrom(
        backgroundColor: primary,
        foregroundColor: textInverse,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: spaceXl, vertical: spaceLg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
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
