import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/Sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/controllers/auth_controller.dart';
import 'package:OKRADISH/gen/assets.gen.dart';
import 'package:OKRADISH/screens/login/reset.dart';
import 'package:OKRADISH/screens/login/signin.dart';
import 'package:OKRADISH/screens/login/signup.dart';
import 'package:video_player/video_player.dart';

enum _Step {
  signin,
  signup,
  reset,
}

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  final vidCtrl = VideoPlayerController.asset(Assets.video.back);
  @override
  void initState() {
    vidCtrl.initialize().then((value) => setState(() {}));
    vidCtrl.setLooping(true);
    vidCtrl.setVolume(0.0);
    vidCtrl.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    vidCtrl.play();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: vidCtrl.value.size.width,
                height: vidCtrl.value.size.height,
                child: VideoPlayer(vidCtrl),
              ),
            ),
          ),
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
