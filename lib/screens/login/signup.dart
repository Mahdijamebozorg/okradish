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

class Signup extends StatelessWidget {
  final GlobalKey<FormState> _formState;
  const Signup(this._formState, {super.key});

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
          const SizedBox(height: Sizes.medium),
          // email
          SizedBox(
            width: size.width * 0.9,
            child: AppTextField(
              color: AppColors.white,
              lable: Strings.email,
              inputType: TextInputType.emailAddress,
              textDirection: TextDirection.ltr,
              maxLength: Data.emailMaxLen,
              onSaved: (String? val) {},
            ),
          ),
          const SizedBox(height: Sizes.medium),
          // password
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
              child:
                  const Text(Strings.register, style: AppTextStyles.colorBtn),
            ),
          ),
        ],
      ),
    );
  }
}
