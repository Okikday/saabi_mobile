import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saabi_mobile/shared/theme/src/app_colors.dart';

/// Saabi app theme — ForUI-based, dark-first with light mode prepared.
///
/// Palette:
///   darkBg        #050505
///   cardBg        #0D0D0D
///   accent        #E45D00
///   accentHover   #CC5200
///   premiumWhite  #FAFAFA
///
/// Typography:
///   Headers / display  → Space Grotesk  (FTypography.display)
///   Body / labels      → Inter          (FTypography.body)
abstract final class SaabiTheme {
  // ============================================================
  // Typography
  // ============================================================
  /// Builds [FTypography] with Inter for body and Space Grotesk for display.
  static FTypography _typography(FColors colors, {required bool touch}) {
    final interFamily = GoogleFonts.inter().fontFamily!;
    final spaceGroteskFamily = GoogleFonts.spaceGrotesk().fontFamily!;

    return FTypography(
      display: FTypeface.inherit(colors: colors, touch: touch, fontFamily: spaceGroteskFamily),
      body: FTypeface.inherit(colors: colors, touch: touch, fontFamily: interFamily),
    );
  }

  // ============================================================
  // Dark theme
  // ============================================================
  /// Returns the ForUI dark [FThemeData] for the Saabi app.
  static FThemeData get dark {
    final colors = FColors(
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.cardBg,
      ),
      barrier: Colors.black54,
      background: AppColors.darkBg,
      foreground: AppColors.premiumWhite,
      primary: AppColors.accent,
      primaryForeground: AppColors.premiumWhite,
      secondary: AppColors.neutralBlack50,
      secondaryForeground: AppColors.premiumWhite,
      muted: AppColors.neutralBlack100,
      mutedForeground: AppColors.neutralBlack400,
      destructive: AppColors.red500,
      destructiveForeground: AppColors.premiumWhite,
      error: AppColors.red500,
      errorForeground: AppColors.premiumWhite,
      card: AppColors.cardBg,
      border: AppColors.neutralBlack100,
    );

    return FThemeData(
      colors: colors,
      touch: true,
      debugLabel: 'Saabi Dark',
      typography: _typography(colors, touch: true),
    );
  }

  // ============================================================
  // Light theme
  // ============================================================
  /// Returns the ForUI light [FThemeData] for the Saabi app.
  static FThemeData get light {
    final colors = FColors(
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.premiumWhite,
      ),
      barrier: Colors.black26,
      background: AppColors.neutralWhite100,
      foreground: AppColors.neutralBlack300,
      primary: AppColors.accent,
      primaryForeground: AppColors.premiumWhite,
      secondary: AppColors.neutralBlack400,
      secondaryForeground: AppColors.premiumWhite,
      muted: AppColors.neutralWhite100,
      mutedForeground: AppColors.neutralBlack400,
      destructive: AppColors.red600,
      destructiveForeground: AppColors.premiumWhite,
      error: AppColors.red600,
      errorForeground: AppColors.premiumWhite,
      card: AppColors.premiumWhite,
      border: AppColors.neutralWhite100,
    );

    return FThemeData(
      colors: colors,
      touch: true,
      debugLabel: 'Saabi Light',
      typography: _typography(colors, touch: true),
    );
  }
}
