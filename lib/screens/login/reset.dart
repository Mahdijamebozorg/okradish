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
import 'package:OKRADISH/utils/validator.dart';
import 'package:OKRADISH/widgets/app_text_field.dart';
import 'package:OKRADISH/widgets/snackbar.dart';

class ResetPwd extends StatelessWidget {
  final GlobalKey<FormState> _formState;
  ResetPwd(this._formState, {super.key});

  final auth = Get.find<AuthController>();

  void saveForm(BuildContext context) async {
    final valid = _formState.currentState!.validate();
    if (valid && !auth.isWorking.value) {
      _formState.currentState!.save();
      final msg = await auth.requestResetPwd();
      if (context.mounted) showSnackbar(context, msg);
      if (msg.isEmpty) {
        if (context.mounted) showSnackbar(context, Messages.emailVersent);
      }
      // Get.offAndToNamed(Screens.home);
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
              lable: Strings.email,
              color: AppColors.white,
              maxLength: Data.passwordMaxLen,
              inputType: TextInputType.emailAddress,
              inputAction: TextInputAction.done,
              validator:
                  AppValidator.textValidator(TextInputType.visiblePassword),
              onSaved: (String? val) {
                auth.email = val!;
              },
            ),
          ),
          SizedBox(
            height:
                max(Sizes.large, MediaQuery.viewInsetsOf(context).bottom - 56),
          ),
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
                    : const Text(Strings.resetPass,
                        style: AppTextStyles.colorBtn),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
