import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案二：深夜咖啡馆 (Midnight Café)
///
/// 设计理念：
/// - 深夜独自坐在咖啡馆的氛围
/// - 暖黄的灯光在深暗背景中显得温馨
/// - 适合睡前使用的舒适暗色模式
/// - 营造独处但不孤单的安心感
///
/// 字体选择逻辑：
/// - 标题：Merriweather (衬线体，有书香气质)
/// - 正文：Source Sans 3 (清晰现代，阅读舒适)
///
/// 情感目标：安心感、被理解、深夜的慰藉
class MidnightCafeTheme {
  // 核心色 - 暖黄灯
  static const Color primary = Color(0xFFE8C547);      // 咖啡馆暖黄
  static const Color primaryLight = Color(0xFFF0D77A);
  static const Color primaryDark = Color(0xFFD4B03A);

  // 辅助色 - 深夜蓝
  static const Color secondary = Color(0xFF5C7A99);    // 深夜窗外的冷色
  static const Color accent = Color(0xFF8B6914);       // 咖啡棕

  // 深色模式背景 - 深夜咖啡馆
  static const Color darkBackground = Color(0xFF141218);   // 极深灰紫
  static const Color darkSurface = Color(0xFF1E1B24);
  static const Color darkSurfaceVariant = Color(0xFF282530);

  // 亮色模式背景 - 清晨咖啡馆
  static const Color lightBackground = Color(0xFFF5F0E8);
  static const Color lightSurface = Color(0xFFFAF7F2);
  static const Color lightSurfaceVariant = Color(0xFFE8E2D8);

  // 深色模式文字
  static const Color darkTextPrimary = Color(0xFFF5F0E8);
  static const Color darkTextSecondary = Color(0xFFB8B0A0);
  static const Color darkTextTertiary = Color(0xFF7A7568);
  static const Color textInverse = Color(0xFF141218);

  // 亮色模式文字
  static const Color lightTextPrimary = Color(0xFF2D2820);
  static const Color lightTextSecondary = Color(0xFF5C5648);
  static const Color lightTextTertiary = Color(0xFF8A8476);

  // 功能色
  static const Color success = Color(0xFF7BA05B);
  static const Color error = Color(0xFFC97064);
  static const Color warning = Color(0xFFE8A838);
  static const Color info = Color(0xFF6B8CAE);

  // 渐变 - 暖光晕
  static const LinearGradient glowGradient = LinearGradient(
    colors: [Color(0xFFE8C547), Color(0xFFF5E6A3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 字体
  static const String fontDisplay = 'Merriweather';
  static const String fontBody = 'Source Sans 3';

  // 间距 - 宽松舒适
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 40.0;
  static const double space2Xl = 64.0;

  // 圆角 - 复古柔和
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // 阴影 - 暖光晕
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x26E8C547),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x40E8C547),
      blurRadius: 24,
      offset: Offset(0, 4),
    ),
  ];

  // 文字样式
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 36,
    fontWeight: FontWeight.w300,
    color: darkTextPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: darkTextPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: darkTextPrimary,
    letterSpacing: 0.1,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: darkTextPrimary,
    height: 1.7,
    letterSpacing: 0.2,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: darkTextSecondary,
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

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: textInverse,
        secondary: secondary,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        background: darkBackground,
        onBackground: darkTextPrimary,
        error: error,
      ),
      scaffoldBackgroundColor: darkBackground,
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
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: accent,
        onPrimary: lightTextPrimary,
        secondary: secondary,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        background: lightBackground,
        onBackground: lightTextPrimary,
        error: error,
      ),
      scaffoldBackgroundColor: lightBackground,
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: lightTextPrimary),
        displayMedium: displayMedium.copyWith(color: lightTextPrimary),
        titleLarge: titleLarge.copyWith(color: lightTextPrimary),
        bodyLarge: bodyLarge.copyWith(color: lightTextPrimary),
        bodyMedium: bodyMedium.copyWith(color: lightTextSecondary),
        labelLarge: labelLarge.copyWith(color: accent),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }
}
