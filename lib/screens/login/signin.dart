import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/data.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/route/screens.dart';
import 'package:okradish/widgets/app_text_field.dart';

class Signin extends StatelessWidget {
  final GlobalKey<FormState> _formState;
  const Signin(this._formState, {super.key});

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
          // username
          SizedBox(
            width: size.width * 0.9,
            child: AppTextField(
              color: AppColors.white,
              lable: Strings.username,
              maxLength: Data.usernameMaxLen,
              onSaved: (String? val) {},
            ),
          ),

          // password
          const SizedBox(height: Sizes.medium),
          SizedBox(
            width: size.width * 0.9,
            child: AppTextField(
              lable: Strings.password,
              color: AppColors.white,
              maxLength: Data.passwordMaxLen,
              textDirection: TextDirection.ltr,
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
          // button
          SizedBox(
            width: size.width * 0.9,
            height: 56,
            child: ElevatedButton(
              style: AppButtonStyles.yellowBtn,
              onPressed: () {
                saveForm();
              },
              child: const Text(Strings.login, style: AppTextStyles.colorBtn),
            ),
          ),
        ],
      ),
    );
  }
}
