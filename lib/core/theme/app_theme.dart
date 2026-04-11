import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'impeccable_options/option_03_urban.dart';

/// 社交App - 都市探险家设计系统
/// 基于Impeccable设计原则创建
///
/// 设计理念：
/// - 现代都市的几何美学
/// - 建筑的线条与色块
/// - 充满活力但保持克制
/// - 探索城市的未知角落
class AppTheme {
  // 私有构造函数，防止实例化
  AppTheme._();

  // ==================== 颜色系统 (来自UrbanExplorer) ====================

  // 核心色 - 都市橙
  static const Color primary = UrbanExplorerTheme.primary;
  static const Color primaryLight = UrbanExplorerTheme.primaryLight;
  static const Color primaryDark = UrbanExplorerTheme.primaryDark;

  // 辅助色 - 建筑灰蓝
  static const Color secondary = UrbanExplorerTheme.secondary;
  static const Color accent = UrbanExplorerTheme.accent;

  // 背景 - 都市白
  static const Color background = UrbanExplorerTheme.background;
  static const Color surface = UrbanExplorerTheme.surface;
  static const Color surfaceVariant = UrbanExplorerTheme.surfaceVariant;

  // 深色模式 - 都市夜
  static const Color darkBackground = UrbanExplorerTheme.darkBackground;
  static const Color darkSurface = UrbanExplorerTheme.darkSurface;
  static const Color darkSurfaceVariant = UrbanExplorerTheme.darkSurfaceVariant;

  // 文字色
  static const Color textPrimary = UrbanExplorerTheme.textPrimary;
  static const Color textSecondary = UrbanExplorerTheme.textSecondary;
  static const Color textTertiary = UrbanExplorerTheme.textTertiary;
  static const Color textInverse = UrbanExplorerTheme.textInverse;

  static const Color darkTextPrimary = UrbanExplorerTheme.darkTextPrimary;
  static const Color darkTextSecondary = UrbanExplorerTheme.darkTextSecondary;
  static const Color darkTextTertiary = UrbanExplorerTheme.darkTextTertiary;

  // 功能色
  static const Color success = UrbanExplorerTheme.success;
  static const Color error = UrbanExplorerTheme.error;
  static const Color warning = UrbanExplorerTheme.warning;
  static const Color info = UrbanExplorerTheme.info;

  // VIP金色
  static const Color vipGold = Color(0xFFC9A962);
  static const Color vipGoldLight = Color(0xFFE0C88A);

  // 渐变色
  static const LinearGradient primaryGradient = UrbanExplorerTheme.sunsetGradient;
  static const LinearGradient vipGradient = LinearGradient(
    colors: [vipGold, vipGoldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== 间距系统 ====================

  static const double spaceXs = UrbanExplorerTheme.spaceXs;
  static const double spaceSm = UrbanExplorerTheme.spaceSm;
  static const double spaceMd = UrbanExplorerTheme.spaceMd;
  static const double spaceLg = UrbanExplorerTheme.spaceLg;
  static const double spaceXl = UrbanExplorerTheme.spaceXl;
  static const double space2Xl = UrbanExplorerTheme.space2Xl;

  // ==================== 圆角系统 ====================

  static const double radiusSm = UrbanExplorerTheme.radiusSm;
  static const double radiusMd = UrbanExplorerTheme.radiusMd;
  static const double radiusLg = UrbanExplorerTheme.radiusLg;
  static const double radiusXl = UrbanExplorerTheme.radiusXl;

  // ==================== 阴影系统 ====================

  static const List<BoxShadow> shadowSm = UrbanExplorerTheme.shadowSm;
  static const List<BoxShadow> shadowMd = UrbanExplorerTheme.shadowMd;
  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 32,
      offset: Offset(0, 12),
    ),
  ];

  // ==================== 字体系统 ====================

  static const String fontFamily = UrbanExplorerTheme.fontBody;
  static const String fontFamilyDisplay = UrbanExplorerTheme.fontDisplay;

  static const TextStyle displayLarge = UrbanExplorerTheme.displayLarge;
  static const TextStyle displayMedium = UrbanExplorerTheme.displayMedium;
  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle titleLarge = UrbanExplorerTheme.titleLarge;

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.5,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle bodyLarge = UrbanExplorerTheme.bodyLarge;
  static const TextStyle bodyMedium = UrbanExplorerTheme.bodyMedium;

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = UrbanExplorerTheme.labelLarge;

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: textTertiary,
    letterSpacing: 0.5,
  );

  // ==================== 主题数据 ====================

  static ThemeData get lightTheme {
    return UrbanExplorerTheme.lightTheme.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXl,
            vertical: spaceLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: labelLarge.copyWith(
            color: textInverse,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXl,
            vertical: spaceLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceLg,
            vertical: spaceMd,
          ),
          textStyle: labelLarge,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spaceLg,
          vertical: spaceLg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: surfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: surfaceVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: bodyMedium.copyWith(color: textSecondary),
        hintStyle: bodyMedium.copyWith(color: textTertiary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        margin: const EdgeInsets.all(spaceMd),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryLight.withOpacity(0.2),
        labelStyle: labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSm),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: surfaceVariant,
        thickness: 1,
        space: spaceLg,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        elevation: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: bodyMedium.copyWith(color: textInverse),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return UrbanExplorerTheme.darkTheme.copyWith(
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textInverse,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spaceXl,
            vertical: spaceLg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
    );
  }
}
