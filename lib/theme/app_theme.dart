import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AppColors — "Botanical Luxe" Light Theme
/// Forest Green meets Golden Amber on a crisp white canvas
/// ─────────────────────────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // ── Forest Green (primary brand) ──────────────────────────────────────────
  static const Color primary       = Color(0xFF2E7D32);   // Deep Forest Green
  static const Color primaryMid    = Color(0xFF388E3C);   // Forest Green
  static const Color primaryLight  = Color(0xFF66BB6A);   // Soft Green
  static const Color primaryPale   = Color(0xFFE8F5E9);   // Barely-there green

  // ── Golden Amber (CTA / accent) ───────────────────────────────────────────
  static const Color gold          = Color(0xFFFFB300);   // Golden Amber
  static const Color goldDark      = Color(0xFFF57F17);   // Deep Amber
  static const Color goldLight     = Color(0xFFFFE082);   // Pale Gold
  static const Color goldPale      = Color(0xFFFFF8E1);   // Cream

  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color background    = Color(0xFFF4FAF4);   // Sage White
  static const Color surface       = Color(0xFFFFFFFF);   // Pure White
  static const Color surfaceAlt    = Color(0xFFF9FCF9);   // Off-white

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1A2E1C);   // Near-black forest
  static const Color textSecondary = Color(0xFF4A6741);   // Muted forest green
  static const Color textHint      = Color(0xFF8FAE88);   // Light muted green
  static const Color textOnDark    = Color(0xFFFFFFFF);
  static const Color textOnGold    = Color(0xFF1A1A00);

  // ── Hero gradient stops ───────────────────────────────────────────────────
  static const Color heroStart     = Color(0xFF2E7D32);
  static const Color heroMid       = Color(0xFF388E3C);
  static const Color heroEnd       = Color(0xFF1B5E20);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success       = Color(0xFF2E7D32);
  static const Color successLight  = Color(0xFFE8F5E9);
  static const Color warning       = Color(0xFFEF6C00);
  static const Color warningLight  = Color(0xFFFFF3E0);
  static const Color error         = Color(0xFFC62828);
  static const Color errorLight    = Color(0xFFFFEBEE);

  // ── UI ────────────────────────────────────────────────────────────────────
  static const Color divider       = Color(0xFFE8F0E8);
  static const Color shadow        = Color(0x142E7D32);   // Green-tinted shadow
  static const Color overlay       = Color(0x801A2E1C);

  // ── Card border ───────────────────────────────────────────────────────────
  static const Color cardBorder    = Color(0xFFDCEDDC);
}

/// ─────────────────────────────────────────────────────────────────────────────
/// AppGradients
/// ─────────────────────────────────────────────────────────────────────────────
class AppGradients {
  AppGradients._();

  static const LinearGradient hero = LinearGradient(
    colors: [AppColors.heroStart, AppColors.heroMid, AppColors.heroEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gold = LinearGradient(
    colors: [Color(0xFFFFCA28), AppColors.gold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient background = LinearGradient(
    colors: [Color(0xFFF4FAF4), Color(0xFFEDF6ED)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGreen = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// ─────────────────────────────────────────────────────────────────────────────
/// AppTextStyles
/// ─────────────────────────────────────────────────────────────────────────────
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get displayLarge => GoogleFonts.poppins(
        fontSize: 34, fontWeight: FontWeight.w800,
        color: AppColors.textPrimary, letterSpacing: -1.0, height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.poppins(
        fontSize: 26, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary, letterSpacing: -0.5,
      );

  static TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 22, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleLarge => GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w400,
        color: AppColors.textPrimary, height: 1.6,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: AppColors.textSecondary, height: 1.55,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: AppColors.textHint, height: 1.4,
      );

  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 15, fontWeight: FontWeight.w700,
        color: AppColors.textPrimary, letterSpacing: 0.2,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w500,
        color: AppColors.textHint, letterSpacing: 0.5,
      );

  static TextStyle get sinhala => GoogleFonts.notoSansSinhala(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get sinhalaHeading => GoogleFonts.notoSansSinhala(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );
}

/// ─────────────────────────────────────────────────────────────────────────────
/// AppTheme
/// ─────────────────────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.textOnDark,
        secondary: AppColors.gold,
        onSecondary: AppColors.textOnGold,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTextStyles.titleLarge,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.textOnGold,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
