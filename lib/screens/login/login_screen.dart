import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/Sizes.dart';
import 'package:okradish/constants/strings.dart';
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
  Widget get textButtons {
    String leftText = '';
    String rightText = '';
    var leftFunc = () {};
    var rightFunc = () {};

    switch (step.value) {
      case _Step.signin:
        {
          leftText = Strings.resetPass;
          leftFunc = () {
            step.value = _Step.reset;
          };
          rightText = Strings.register;
          rightFunc = () {
            step.value = _Step.signup;
          };
        }
        break;
      case _Step.signup:
        {
          leftText = Strings.resetPass;
          leftFunc = () {
            step.value = _Step.reset;
          };
          rightText = Strings.login;
          rightFunc = () {
            step.value = _Step.signin;
          };
        }
      default:
        {
          leftText = Strings.register;
          leftFunc = () {
            step.value = _Step.signup;
          };
          rightText = Strings.login;
          rightFunc = () {
            step.value = _Step.signin;
          };
        }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: rightFunc,
          child: Text(rightText, style: AppTextStyles.loginTextBtn),
        ),
        const Text('/', style: AppTextStyles.loginTextBtn),
        TextButton(
          onPressed: leftFunc,
          child: Text(leftText, style: AppTextStyles.loginTextBtn),
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
                  textButtons,
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
