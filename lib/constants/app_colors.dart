import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color darkBg = Color(0xFF091413);      // #091413
  static const Color darkGreen = Color(0xFF285A48);   // #285A48
  static const Color mediumGreen = Color(0xFF408A71); // #408A71
  static const Color lightGreen = Color(0xFFB0E4CC);  // #B0E4CC
  static const Color lightBg = Color(0xFFF3F4F4);     // #F3F4F4

  // Semantic colors
  static const Color primary = mediumGreen;
  static const Color primaryDark = darkGreen;
  static const Color background = lightBg;
  static const Color error = Color(0xFFEF4444);
  static const Color success = lightGreen;
}

class AppStyles {
  static const double borderRadius = 12.0;
  static const double inputPadding = 16.0;
  static const double verticalPadding = 14.0;
}
