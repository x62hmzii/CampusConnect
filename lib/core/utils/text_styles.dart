import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TextStyles {
  static TextStyle heading({double fontSize = 24, Color color = AppColors.textDark}) {
    return TextStyle(
      fontFamily: 'Sourgammy',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle body({double fontSize = 16, Color color = AppColors.textLight}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
    );
  }
}