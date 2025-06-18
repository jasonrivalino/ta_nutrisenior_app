import 'package:flutter/material.dart';
import 'fonts.dart';

class AppTextStyles {
  static TextStyle textBold({
    required double size,
    required Color color,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.bold,
      fontFamily: AppFonts.fontBold,
    );
  }

  static TextStyle textMedium({
    required double size,
    required Color color,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.fontMedium,
    );
  }
}