import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/colors.dart';
import 'package:OKRADISH/constants/data.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/controllers/auth_controller.dart';
import 'package:OKRADISH/route/screens.dart';
import 'package:OKRADISH/utils/validator.dart';
import 'package:OKRADISH/widgets/app_text_field.dart';
import 'dart:developer' as dev;

import 'package:OKRADISH/widgets/snackbar.dart';

class Signup extends StatelessWidget {
  final GlobalKey<FormState> _formState;
  Signup(this._formState, {super.key});

  final auth = Get.find<AuthController>();

  void saveForm(BuildContext context) async {
    final valid = _formState.currentState!.validate();
    if (valid && !auth.isWorking.value) {
      _formState.currentState!.save();

      var msg = await auth.singUp();
      // if error on signup
      if (msg.isNotEmpty) {
        if (context.mounted) showSnackbar(context, msg);
        dev.log(msg);
      } else {
        msg = await auth.signIn();
        // if error on signin
        if (msg.isNotEmpty) {
          if (context.mounted) showSnackbar(context, msg);
          dev.log(msg);
        } else {
          // if (context.mounted) showSnackbar(context, Messages.emailVersent);
          Get.offAndToNamed(Screens.home);
        }
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
                auth.username = val!.toLowerCase();
              },
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
              validator: AppValidator.textValidator(TextInputType.emailAddress),
              onSaved: (String? val) {
                auth.email = val!.toLowerCase();
              },
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
              validator:
                  AppValidator.textValidator(TextInputType.visiblePassword),
              onSaved: (String? val) {
                auth.password = val!;
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
                  saveForm(context);
                },
                child: auth.isWorking.value
                    ? const Center(child: CircularProgressIndicator())
                    : const Text(Strings.register,
                        style: AppTextStyles.colorBtn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
