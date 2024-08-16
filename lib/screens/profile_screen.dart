import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/data.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/widgets/app_text_field.dart';
import 'package:okradish/widgets/appbar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen(this._formKey, {super.key});
  final GlobalKey<FormState> _formKey;

// TODO: save form
  saveForm() {
    _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
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
                  child: Column(
                    children: [
                      // username
                      AppTextField(
                        color: AppColors.black,
                        lable: Strings.username,
                        maxLength: Data.usernameMaxLen,
                        inputAction: TextInputAction.done,
                        onSaved: (value) {},
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
                        onSaved: (value) {},
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
                        onSaved: (value) {},
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
                        onSaved: (value) {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Sizes.bigBtnH,
                width: size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    saveForm();
                  },
                  style: AppButtonStyles.highlightBtn,
                  child: const Text(
                    Strings.editAcount,
                    style: AppTextStyles.highlight,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
