import 'package:flutter/material.dart';
import 'package:OKRADISH/gen/fonts.gen.dart';
import 'package:OKRADISH/constants/colors.dart';

class AppTextStyles {
  AppTextStyles._();

// Body
  static const TextStyle pageTitle = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 24,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle gram = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 18,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle weightNumber = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 68,
    color: AppColors.black,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 16,
    color: AppColors.black,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyExtreme = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 30,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyMeduim = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.black,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 12,
    color: AppColors.black,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyTiny = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 8,
    color: AppColors.black,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle search = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 16,
    color: AppColors.trunks,
    fontWeight: FontWeight.normal,
  );

  // Labeles
  static const TextStyle loginTextField = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.white,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle accountTextField = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.black,
    fontWeight: FontWeight.normal,
  );

  // Buttons
  static const TextStyle highlight = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 16,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle smallHighlight = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle colorBtn = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 16,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle blackBtn = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.white,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle borderBtn = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle loginTextBtn = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textBtn = TextStyle(
    fontFamily: FontFamily.estedad,
    fontSize: 14,
    color: AppColors.black,
    fontWeight: FontWeight.bold,
  );
}
