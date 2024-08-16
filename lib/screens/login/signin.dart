import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/data.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/controllers/auth_controller.dart';
import 'package:okradish/route/screens.dart';
import 'package:okradish/utils/validator.dart';
import 'package:okradish/widgets/app_text_field.dart';

class Signin extends StatelessWidget {
  final GlobalKey<FormState> _formState;
  Signin(this._formState, {super.key});

  final auth = Get.find<AuthController>();
  final RxBool waiting = RxBool(false);

  void saveForm() async {
    final valid = _formState.currentState!.validate();
    if (valid && !waiting.value) {
      waiting.value = true;
      _formState.currentState!.save();
      await auth.signIn();
      waiting.value = false;
      if (valid) {
        Get.toNamed(Screens.home);
      }
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
              validator: AppValidator.textValidator(TextInputType.name),
              onSaved: (String? val) {
                auth.username = val ?? "";
              },
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
              validator:
                  AppValidator.textValidator(TextInputType.visiblePassword),
              onSaved: (String? val) {
                auth.password = val ?? "";
              },
            ),
          ),

          SizedBox(
            height:
                max(Sizes.large, MediaQuery.viewInsetsOf(context).bottom - 56),
          ),
          // button
          Obx(
            () => SizedBox(
              width: size.width * 0.9,
              height: 56,
              child: ElevatedButton(
                style: AppButtonStyles.yellowBtn,
                onPressed: () {
                  saveForm();
                },
                child: waiting.value
                    ? const Center(child: CircularProgressIndicator())
                    : const Text(Strings.login, style: AppTextStyles.colorBtn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
