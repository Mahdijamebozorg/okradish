import 'package:flutter/material.dart';
import 'package:okradish/constants/colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackbar(
    BuildContext context, Widget content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.greyBack,
      duration: const Duration(seconds: 2),
      content: content,
    ),
  );
}
