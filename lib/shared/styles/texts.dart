import 'package:flutter/material.dart';
import 'fonts.dart';

class AppTextStyles {
  static TextStyle textBold({
    required double size,
    required Color color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.bold,
      fontFamily: AppFonts.fontBold,
      decoration: decoration ?? TextDecoration.none,
      height: height,
    );
  }

  static TextStyle textMedium({
    required double size,
    required Color color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w500,
      fontFamily: AppFonts.fontMedium,
      decoration: decoration ?? TextDecoration.none,
      height: height,
    );
  }

  static TextStyle textRegular({
    required double size,
    required Color color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: size,
      color: color,
      fontWeight: FontWeight.w400,
      fontFamily: AppFonts.fontMedium,
      decoration: decoration ?? TextDecoration.none,
      height: height,
    );
  }
}