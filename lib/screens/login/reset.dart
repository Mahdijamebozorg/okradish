import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/data.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/route/screens.dart';
import 'package:okradish/widgets/app_text_field.dart';

class ResetPwd extends StatelessWidget {
  final GlobalKey<FormState> _formState;
  const ResetPwd(this._formState, {super.key});

  void saveForm() {
    final valid = _formState.currentState!.validate();
    if (valid) {
      Get.toNamed(Screens.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Form(
      key: _formState,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.9,
            child: AppTextField(
              lable: Strings.password,
              color: AppColors.white,
              maxLength: Data.passwordMaxLen,
              inputType: TextInputType.visiblePassword,
              isPasword: true,
              inputAction: TextInputAction.done,
              onSaved: (String? val) {},
            ),
          ),
          SizedBox(
            height:
                max(Sizes.large, MediaQuery.viewInsetsOf(context).bottom - 56),
          ),
          SizedBox(
            width: size.width * 0.9,
            height: 56,
            child: ElevatedButton(
              style: AppButtonStyles.yellowBtn,
              onPressed: () {
                saveForm();
              },
              child:
                  const Text(Strings.resetPass, style: AppTextStyles.colorBtn),
            ),
          ),
        ],
      ),
    );
  }
}
