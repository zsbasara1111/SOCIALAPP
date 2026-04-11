import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 方案G: 手绘插画风
/// 特点: 不规则边框、手写体、蜡笔色彩、手绘元素
class HandDrawnTheme {
  // 颜色系统 - 蜡笔色彩
  static const Color background = Color(0xFFFEFCF7); // 米纸白
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFFFF6B6B); // 珊瑚蜡笔
  static const Color secondary = Color(0xFF4ECDC4); // 薄荷蜡笔
  static const Color accent = Color(0xFFFFE66D); // 柠檬蜡笔
  static const Color textPrimary = Color(0xFF2C3E50); // 深灰蓝
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color pencil = Color(0xFF34495E); // 铅笔灰

  // 间距 - 活泼跳跃
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  // 圆角 - 不规则手绘感
  static const double radiusSm = 8;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusXl = 32;

  // 字体 - 手写体
  static const String fontFamily = 'Comic Sans MS';
  static const String fontFamilyDisplay = 'Marker Felt';

  // 手绘边框
  static BoxDecoration handDrawnDecoration(Color color) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radiusMd),
        topRight: Radius.circular(radiusLg),
        bottomLeft: Radius.circular(radiusXl),
        bottomRight: Radius.circular(radiusSm),
      ),
      border: Border.all(
        color: color,
        width: 2.5,
      ),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 0,
          offset: const Offset(4, 4),
        ),
      ],
    );
  }

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
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 2.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLg),
          ),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
