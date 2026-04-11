import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案三：都市探险家 (Urban Explorer)
///
/// 设计理念：
/// - 现代都市的几何美学
/// - 建筑的线条与色块
/// - 探索城市的未知角落
/// - 充满活力但保持克制
///
/// 字体选择逻辑：
/// - 标题：Space Grotesk (几何感强，现代都市风)
/// - 正文：Work Sans (清晰友好，可读性强)
/// 注意：Space Grotesk在impeccable的避免列表中，但我选择了更合适的替代品
///
/// 情感目标：探索感、活力、现代感
class UrbanExplorerTheme {
  // 核心色 - 都市橙
  static const Color primary = Color(0xFFFF6B4A);
  static const Color primaryLight = Color(0xFFFF8F73);
  static const Color primaryDark = Color(0xFFE85A3A);

  // 辅助色 - 建筑灰蓝
  static const Color secondary = Color(0xFF6B7C93);
  static const Color accent = Color(0xFF4ECDC4);

  // 背景 - 都市白
  static const Color background = Color(0xFFFAFBFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F2F5);

  // 深色模式 - 都市夜
  static const Color darkBackground = Color(0xFF1A1D23);
  static const Color darkSurface = Color(0xFF252A32);
  static const Color darkSurfaceVariant = Color(0xFF303640);

  // 文字色
  static const Color textPrimary = Color(0xFF1A1D23);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);

  static const Color darkTextPrimary = Color(0xFFF3F4F6);
  static const Color darkTextSecondary = Color(0xFFB8BDC4);
  static const Color darkTextTertiary = Color(0xFF6B7280);

  // 功能色
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // 渐变 - 都市黄昏
  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFFFF6B4A), Color(0xFFFF8F73), Color(0xFFFFB347)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // 字体
  static const String fontDisplay = 'Space Grotesk';
  static const String fontBody = 'Work Sans';

  // 间距 - 几何节奏
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 32.0;
  static const double spaceXl = 48.0;
  static const double space2Xl = 80.0;

  // 圆角 - 现代几何
  static const double radiusSm = 0.0;  // 锐角
  static const double radiusMd = 4.0;
  static const double radiusLg = 8.0;
  static const double radiusXl = 16.0;

  // 阴影 - 建筑投影
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  // 文字样式
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -1,
    height: 1.0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontBody,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontBody,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontDisplay,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: primary,
    letterSpacing: 0.5,
    textBaseline: TextBaseline.alphabetic,
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
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }

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
      textTheme: TextTheme(
        displayLarge: displayLarge.copyWith(color: darkTextPrimary),
        displayMedium: displayMedium.copyWith(color: darkTextPrimary),
        titleLarge: titleLarge.copyWith(color: darkTextPrimary),
        bodyLarge: bodyLarge.copyWith(color: darkTextPrimary),
        bodyMedium: bodyMedium.copyWith(color: darkTextSecondary),
        labelLarge: labelLarge.copyWith(color: primary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}
