import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/Sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/controllers/auth_controller.dart';
import 'package:okradish/gen/assets.gen.dart';
import 'package:okradish/screens/login/reset.dart';
import 'package:okradish/screens/login/signin.dart';
import 'package:okradish/screens/login/signup.dart';

enum _Step {
  signin,
  signup,
  reset,
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final step = _Step.signin.obs;
  final authCtrl = Get.find<AuthController>();

  final singInFormState = GlobalKey<FormState>();
  final signupFormState = GlobalKey<FormState>();
  final resetFormState = GlobalKey<FormState>();

  /// Screen main widget
  Widget get currentWidget {
    if (step.value == _Step.signin) {
      return Signin(singInFormState);
    } else if (step.value == _Step.signup) {
      return Signup(signupFormState);
    } else {
      return ResetPwd(resetFormState);
    }
  }

  /// Text buttons
  Widget textButtons(BuildContext context) {
    String leftText = '';
    String rightText = '';
    switch (step.value) {
      case _Step.signin:
        {
          leftText = Strings.resetPass;
          rightText = Strings.register;
        }
        break;
      case _Step.signup:
        {
          leftText = Strings.resetPass;
          rightText = Strings.login;
        }
      default:
        {
          leftText = Strings.register;
          rightText = Strings.login;
        }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            if (step.value == _Step.signin) {
              step.value = _Step.signup;
            } else if (step.value == _Step.signup) {
              step.value = _Step.signin;
            } else {
              step.value = _Step.signin;
            }
          },
          child: authCtrl.isWorking.value
              ? const Center(child: CircularProgressIndicator())
              : Text(rightText, style: AppTextStyles.loginTextBtn),
        ),
        const Text('/', style: AppTextStyles.loginTextBtn),
        TextButton(
          onPressed: () async {
            if (step.value == _Step.signin) {
              step.value = _Step.reset;
            } else if (step.value == _Step.signup) {
              step.value = _Step.reset;
            } else {
              step.value = _Step.signup;
            }
          },
          child: authCtrl.isWorking.value
              ? const Center(child: CircularProgressIndicator())
              : Text(leftText, style: AppTextStyles.loginTextBtn),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: Assets.png.background.image(fit: BoxFit.fill)),
          Positioned(
            bottom: MediaQuery.viewInsetsOf(context).bottom > 10 ? 0 : 80,
            left: 0,
            right: 0,
            top: 0,
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: currentWidget),
                  const SizedBox(height: Sizes.medium),
                  textButtons(context),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: Sizes.medium,
            child: Image.asset(Assets.png.logo.path, height: 34, width: 150),
          )
        ],
      ),
    );
  }
}
