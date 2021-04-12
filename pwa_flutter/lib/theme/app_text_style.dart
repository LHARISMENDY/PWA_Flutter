import 'package:flutter/material.dart';
import 'package:pwa_flutter/theme/app_colors.dart';

/// TextStyle used in the app.
class AppTextStyle {
  const AppTextStyle._();

  static TextStyle get title => TextStyle(
        color: AppColors.titleColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get body => TextStyle(
        color: AppColors.textColor,
        fontSize: 12,
      );
}
