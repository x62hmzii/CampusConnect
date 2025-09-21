import 'package:campusconnect/core/constants/app_colors.dart';
import 'package:campusconnect/core/utils/text_styles.dart';
import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primaryColor: AppColors.primary,
  fontFamily: 'DefaultFont',
  textTheme: TextTheme(
    headlineMedium: TextStyles.heading(fontSize: 24),
    bodyLarge: TextStyles.body(), //
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    titleTextStyle: TextStyles.heading(color: Colors.white),
  ),
);