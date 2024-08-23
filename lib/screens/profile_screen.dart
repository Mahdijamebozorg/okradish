import 'dart:developer';

import 'package:OKRADISH/route/screens.dart';
import 'package:OKRADISH/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:OKRADISH/widgets/appbar.dart';

class ProfileScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  ProfileScreen(this._formKey, {super.key});

  final user = Get.find<AuthController>();

  saveForm(BuildContext context) async {
    final valid = _formKey.currentState!.validate();
    if (valid) {
      _formKey.currentState!.save();
      final msg = await user.submitData();
      if (msg.isNotEmpty) {
        showSnackbar(context, msg);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log("----- ProfileScreen rebult");
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: const MyAppBar(title: Strings.account),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.medium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.viewInsetsOf(context).bottom > 10
                              ? MediaQuery.viewInsetsOf(context).bottom -
                                  (
                                      // main body padding
                                      Sizes.large +
                                          Sizes.btmNavH +
                                          // margins
                                          Sizes.medium * 3 +
                                          // buttons
                                          Sizes.smallBtnH * 2)
                              : 0),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            // username
                            AppTextField(
                              color: AppColors.black,
                              lable: Strings.username,
                              maxLength: Data.usernameMaxLen,
                              inputAction: TextInputAction.done,
                              initalValue: user.username,
                              validator: AppValidator.textValidator(
                                  TextInputType.name),
                              onSaved: (value) {
                                user.username = value!;
                              },
                            ),
                            const SizedBox(height: Sizes.medium),
                            // email
                            AppTextField(
                              color: AppColors.black,
                              lable: Strings.email,
                              inputType: TextInputType.emailAddress,
                              textDirection: TextDirection.ltr,
                              maxLength: Data.emailMaxLen,
                              inputAction: TextInputAction.done,
                              initalValue: user.email,
                              validator: AppValidator.textValidator(
                                  TextInputType.emailAddress),
                              onSaved: (value) {
                                user.email = value!;
                              },
                            ),
                            const SizedBox(height: Sizes.medium),
                            // phone
                            AppTextField(
                              color: AppColors.black,
                              lable: Strings.phone,
                              inputType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textDirection: TextDirection.ltr,
                              maxLength: Data.phoneMaxLen,
                              inputAction: TextInputAction.done,
                              initalValue: user.phone,
                              validator: AppValidator.textValidator(
                                  TextInputType.phone),
                              onSaved: (value) {
                                user.phone = value!;
                              },
                            ),
                            const SizedBox(height: Sizes.medium),
                            // password
                            AppTextField(
                              color: AppColors.black,
                              lable: Strings.password,
                              maxLength: Data.passwordMaxLen,
                              textDirection: TextDirection.ltr,
                              inputType: TextInputType.visiblePassword,
                              isPasword: true,
                              inputAction: TextInputAction.done,
                              initalValue: user.password,
                              validator: AppValidator.textValidator(
                                  TextInputType.visiblePassword),
                              onSaved: (value) {
                                user.password = value!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Sizes.medium),

                // Save
                Obx(
                  () => SizedBox(
                    height: Sizes.smallBtnH,
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () async {
                        await saveForm(context);
                      },
                      style: AppButtonStyles.highlightBtn,
                      child: user.isWorking.value
                          ? const Center(child: CircularProgressIndicator())
                          : const Text(
                              Strings.editAcount,
                              style: AppTextStyles.highlight,
                            ),
                    ),
                  ),
                ),
                SizedBox(height: Sizes.medium),

                // Logout
                Obx(
                  () => SizedBox(
                    height: Sizes.smallBtnH,
                    width: size.width * 0.9,
                    child: user.isWorking.value
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        actions: [
                                          // true
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text(
                                              Strings.confirm,
                                              style: AppTextStyles.bodyMeduim,
                                            ),
                                          ),
                                          // false
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text(
                                              Strings.cancel,
                                              style: AppTextStyles.bodyMeduim,
                                            ),
                                          ),
                                        ],
                                        title: Text(Strings.logoutAlert,
                                            style: AppTextStyles.bodyMeduim),
                                      )).then((value) async {
                                if (value == null) return;
                                if (value) {
                                  final msg = await user.signOut();
                                  if (msg.isNotEmpty) {
                                    showSnackbar(context, msg);
                                  } else {
                                    Get.offAndToNamed(Screens.login);
                                  }
                                }
                                ;
                              });
                            },
                            style: AppButtonStyles.blackBtnStyle,
                            child: const Text(
                              Strings.logout,
                              style: AppTextStyles.blackBtn,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
