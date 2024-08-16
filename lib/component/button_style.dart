import 'package:flutter/material.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';

class AppButtonStyles {
  AppButtonStyles._();

  static ButtonStyle blackBtnStyle = ButtonStyle(
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
    elevation: const WidgetStatePropertyAll(0.0),
    backgroundColor: const WidgetStatePropertyAll(AppColors.black),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.blackBtn),
  );

  static ButtonStyle borderBtnStyle = ButtonStyle(
    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: AppColors.black))),
    elevation: const WidgetStatePropertyAll(0.0),
    backgroundColor: const WidgetStatePropertyAll(AppColors.white),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.blackBtn),
  );

  static ButtonStyle highlightBtn = ButtonStyle(
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
    elevation: const WidgetStatePropertyAll(0.0),
    backgroundColor: const WidgetStatePropertyAll(AppColors.darkGreen),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.highlight),
  );

  static ButtonStyle orangeBtn = ButtonStyle(
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
    elevation: const WidgetStatePropertyAll(0.0),
    backgroundColor: const WidgetStatePropertyAll(AppColors.orange),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.colorBtn),
  );

  static ButtonStyle yellowBtn = ButtonStyle(
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
    elevation: const WidgetStatePropertyAll(0.0),
    backgroundColor: const WidgetStatePropertyAll(AppColors.primaryColor),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.colorBtn),
  );

  static ButtonStyle textButton = ButtonStyle(
    shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
    elevation: const WidgetStatePropertyAll(0.0),
    backgroundColor: const WidgetStatePropertyAll(AppColors.transparent),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.borderBtn),
    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8.0)),
  );

  static ButtonStyle textButtonBorder = ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.black.withOpacity(0.2))),
    ),
    elevation: const WidgetStatePropertyAll(0.0),
    backgroundColor: const WidgetStatePropertyAll(AppColors.transparent),
    textStyle: const WidgetStatePropertyAll(AppTextStyles.borderBtn),
    padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8.0)),
  );
}
