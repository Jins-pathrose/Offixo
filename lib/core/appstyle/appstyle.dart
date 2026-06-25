import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF2294D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Color primaryColor = Color(0xFF06B6D4);
  static const Color fontColor = Color(0xFF232323);
  static const Color backgroundColor = Color(0xFFF3F4F6);
  static const Color hintColor = Color(0xFF9CA3AF);
  static const Color borderColor = Color(0xFFE5E7EB);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color sectionColor = Color(0xFF06B6D4);
 
  static TextStyle text({
    double size = 14,
    Color? color,
    FontWeight weight = FontWeight.w400,
    double height = 1.4,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? fontColor,
      fontWeight: weight,
      height: height,
    );
  }
}