import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SaabiTheme {
  static const Color darkBg = Color(0xFF050505);
  static const Color cardBg = Color(0xFF0D0D0D);
  static const Color accent = Color(0xFFE45D00);
  static const Color accentHover = Color(0xFFCC5200);
  static const Color premiumWhite = Color(0xFFFAFAFA);

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: Brightness.dark,
      surface: cardBg,
    ).copyWith(
      primary: accent,
      secondary: accent,
      surface: cardBg,
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
        headlineSmall: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }
}
