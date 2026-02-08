import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


const backgroundColor = Color(0xFFF7F4FA); // soft lavender
const primaryBlue = Color(0xFF4F8DF7);
const cardColor = Colors.white;
const textPrimary = Color(0xFF1F1F1F);
const textSecondary = Color(0xFF7A7A7A);

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: backgroundColor,
  textTheme: GoogleFonts.poppinsTextTheme(
  const TextTheme(
    headlineLarge: TextStyle(fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(fontSize: 15),
  ),
),


  // ✅ AppBar styling (THIS fixes the pink/grey bar issue)
  appBarTheme: const AppBarTheme(
    backgroundColor: backgroundColor,
    elevation: 0,
    foregroundColor: textPrimary,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    iconTheme: IconThemeData(color: textPrimary),
  ),

  // ✅ Bottom navigation consistency
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: backgroundColor,
    selectedItemColor: primaryBlue,
    unselectedItemColor: textSecondary,
    elevation: 8,
  ),

  // ✅ Button style
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);
