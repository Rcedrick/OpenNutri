import 'package:flutter/material.dart';

class AppColors {
  // Couleurs Light Theme
  static const Color lightPrimary = Color(0xFF6A1B9A);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightText = Colors.black87;
  static const Color lightCard = Colors.white;

  // Couleurs Dark Theme
  static const Color darkPrimary = Color(0xFFAB47BC);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkText = Colors.white;
  static const Color darkCard = Color(0xFF1E1E1E);

  // Dégradé principal (peut être dynamique aussi)
  static LinearGradient mainGradient(bool isDark) {
    return LinearGradient(
      colors: isDark
          ? [darkPrimary, Colors.deepPurpleAccent]
          : [lightPrimary, Colors.deepPurple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
