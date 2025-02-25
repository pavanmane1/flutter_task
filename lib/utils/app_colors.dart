import 'package:flutter/material.dart';

class AppColors {
  // **Primary Theme Colors**
  static const Color primary = Color.fromARGB(223, 32, 76, 196);
  static const Color secondary = Color(0xFFB9C7EF);

  // **Background Colors**
  static const Color background = Color(0xFFF5F5F5);
  static const backgroundMainColor = Color.fromARGB(255, 247, 244, 244);
  static final Color backgroundSecondary = Colors.grey[400]!;
  static const Color cardBackground = Color(0xFFFFFFFF);
  static final LinearGradient cardBackgroundGradiant = LinearGradient(
    colors: [Color.fromARGB(255, 74, 95, 255), Color.fromARGB(255, 27, 49, 211)],
  );

  // **Text Colors**
  static const Color textPrimary = Color(0xFF000000); // Black
  static const Color textSecondary = Color.fromARGB(255, 24, 23, 23);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textinfo = Color(0xFF295ADF);

  // **Button Colors**
  static const Color buttonPrimary = Color(0xFF295ADF);
  static const Color buttonSecondary = Color(0xFFB9C7EF);
}
