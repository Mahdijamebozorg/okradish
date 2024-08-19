import 'package:flutter/material.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/screens/add/add_screen.dart';
import 'package:okradish/widgets/app_card.dart';

class Init extends StatelessWidget {
  final void Function(AddStep) changeState;
  const Init(this.changeState, {super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppCard(
      child: Column(
        children: [
          const Text(
            Strings.addFoodText,
            style: AppTextStyles.bodyMeduim,
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            height: Sizes.bigBtnH,
            width: size.width * 0.9,
            child: ElevatedButton(
              style: AppButtonStyles.orangeBtn,
              onPressed: () => changeState(AddStep.weighting),
              child: const Text(
                textAlign: TextAlign.center,
                Strings.startWeighing,
                style: AppTextStyles.colorBtn,
              ),
            ),
          )
        ],
      ),
    );
  }
}
