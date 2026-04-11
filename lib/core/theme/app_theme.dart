import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 社交App - 奶油甜心风设计系统
/// 基于Impeccable设计原则创建
class AppTheme {
  // 私有构造函数，防止实例化
  AppTheme._();

  // ==================== 颜色系统 ====================

  // 主色调 - 珊瑚粉
  static const Color primary = Color(0xFFFF9AA2);
  static const Color primaryLight = Color(0xFFFFB7B2);
  static const Color primaryDark = Color(0xFFFF8585);

  // 辅色 - 蜜桃 & 薄荷
  static const Color secondary = Color(0xFFFFB4A2);
  static const Color accent = Color(0xFFA2E1D8);
  static const Color accentLight = Color(0xFFB5EAD7);

  // 背景色 - 奶油白
  static const Color background = Color(0xFFFFF9F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFFFF5F0);

  // 文字色
  static const Color textPrimary = Color(0xFF4A4A4A);
  static const Color textSecondary = Color(0xFF8B8680);
  static const Color textTertiary = Color(0xFFB5B0AA);
  static const Color textInverse = Color(0xFFFFFFFF);

  // 功能色
  static const Color success = Color(0xFFB5EAD7);
  static const Color successDark = Color(0xFF7FD8BE);
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFFB4B4);
  static const Color warning = Color(0xFFFFD93D);
  static const Color info = Color(0xFFA0E7E5);

  // VIP金色
  static const Color vipGold = Color(0xFFD4A853);
  static const Color vipGoldLight = Color(0xFFE8D5A3);

  // 渐变色
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient vipGradient = LinearGradient(
    colors: [vipGold, vipGoldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== 间距系统 ====================

  static const double spacingUnit = 4.0;

  static const double spaceXs = spacingUnit;      // 4
  static const double spaceSm = spacingUnit * 2;  // 8
  static const double spaceMd = spacingUnit * 3;  // 12
  static const double spaceLg = spacingUnit * 4;  // 16
  static const double spaceXl = spacingUnit * 6;  // 24
  static const double space2Xl = spacingUnit * 8; // 32
  static const double space3Xl = spacingUnit * 12;// 48
  static const double space4Xl = spacingUnit * 16;// 64

  // ==================== 圆角系统 ====================

  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;
  static const double radius2Xl = 48.0;
  static const double radiusFull = 9999.0;

  // ==================== 阴影系统 ====================

  static const List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 24,
      offset: Offset(0, 12),
    ),
  ];

  // ==================== 字体系统 ====================

  static const String fontFamily = 'PingFang SC';
  static const String fontFamilyDisplay = 'PingFang SC';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamilyDisplay,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
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

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w500,
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

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textTertiary,
    height: 1.4,
  );

  // ==================== 主题数据 ====================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: textInverse,
        primaryContainer: primaryLight,
        onPrimaryContainer: textPrimary,
        secondary: secondary,
        onSecondary: textPrimary,
        secondaryContainer: surfaceVariant,
        onSecondaryContainer: textPrimary,
        surface: surface,
        onSurface: textPrimary,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: textSecondary,
        background: background,
        onBackground: textPrimary,
        error: error,
        onError: textInverse,
        outline: textTertiary,
      ),
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headlineSmall,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
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
            borderRadius: BorderRadius.circular(radiusFull),
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
            borderRadius: BorderRadius.circular(radiusFull),
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
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: textTertiary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: textTertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: bodyMedium.copyWith(color: textSecondary),
        hintStyle: bodyMedium.copyWith(color: textTertiary),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXl),
        ),
        margin: const EdgeInsets.all(spaceMd),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        selectedColor: primaryLight,
        labelStyle: labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMd,
          vertical: spaceXs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
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
          borderRadius: BorderRadius.circular(radiusXl),
        ),
        elevation: 24,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: bodyMedium.copyWith(color: textInverse),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
