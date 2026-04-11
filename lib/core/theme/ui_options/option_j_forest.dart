import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案J：清新森系风
///
/// 设计理念：
/// - 森林绿主调
/// - 自然清新配色
/// - 氧气感设计
/// - 生机与活力
class ForestTheme {
  // 主色调 - 森林绿
  static const Color primary = Color(0xFF2D6A4F);
  static const Color primaryLight = Color(0xFF40916C);
  static const Color primaryDark = Color(0xFF1B4332);

  // 辅色 - 嫩芽黄绿
  static const Color secondary = Color(0xFF95D5B2);
  static const Color accent = Color(0xFFD8F3DC);

  // 背景色 - 清新白绿
  static const Color background = Color(0xFFF1F8F4);
  static const Color surface = Color(0xFFFAFDFB);
  static const Color surfaceVariant = Color(0xFFE8F5E9);

  // 文字色 - 深绿灰
  static const Color textPrimary = Color(0xFF1B4332);
  static const Color textSecondary = Color(0xFF52796F);
  static const Color textTertiary = Color(0xFF84A098);
  static const Color textInverse = Color(0xFFFAFDFB);

  // 功能色
  static const Color success = Color(0xFF40916C);
  static const Color error = Color(0xFFE07A5F);
  static const Color warning = Color(0xFFF2CC8F);
  static const Color info = Color(0xFF81B29A);

  // 圆角 - 自然圆润
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;

  // 阴影 - 清新绿调
  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A2D6A4F),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x262D6A4F),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x332D6A4F),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // 字体 - 清新自然
  static const String fontFamily = 'Nunito';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: 0,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: primary,
    letterSpacing: 0.3,
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
          elevation: 2,
          shadowColor: const Color(0x402D6A4F),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shadowColor: const Color(0x402D6A4F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
    );
  }
}
