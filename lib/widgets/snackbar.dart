import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
    BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.greyBack,
      duration: const Duration(seconds: 2),
      content: Text(message, style: AppTextStyles.bodyMeduim),
    ),
  );
}

GetSnackBar getSnackBar(String message) {
  return GetSnackBar(
    title: message,
    message: " ",
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 2),
    animationDuration: const Duration(milliseconds: 500),
    padding: EdgeInsets.fromLTRB(
      Sizes.medium,
      Sizes.medium,
      Sizes.medium,
      Sizes.medium + MediaQuery.viewInsetsOf(Get.context!).bottom,
    ),
  );
}

// SnackbarController getSnackBar(String message) {
//   Get.closeCurrentSnackbar();
//   return Get.rawSnackbar(
//     title: message,
//     message: "",
//     snackPosition: SnackPosition.BOTTOM,
//     duration: const Duration(seconds: 2),
//     animationDuration: const Duration(milliseconds: 500),
//     padding: EdgeInsets.fromLTRB(
//       Sizes.medium,
//       Sizes.medium,
//       Sizes.medium,
//       Sizes.medium + MediaQuery.viewInsetsOf(Get.context!).bottom,
//     ),
//   );
// }
