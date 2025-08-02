import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Inter',
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.poppins(fontSize: 36, fontWeight: FontWeight.w700),
        bodyLarge: GoogleFonts.inter(fontSize: 16, height: 1.6),
        bodyMedium: GoogleFonts.inter(fontSize: 14, height: 1.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}