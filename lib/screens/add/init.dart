import 'package:flutter/material.dart';

import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/screens/add/add_screen.dart';
import 'package:OKRADISH/widgets/app_card.dart';

class Init extends StatelessWidget {
  const Init({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AppCard(
      child: Column(
        children: [
          const Text(
            Strings.addFoodText,
            style: AppTextStyles.bodyMeduim,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            height: Sizes.bigBtnH,
            width: size.width * 0.9,
            child: ElevatedButton(
              style: AppButtonStyles.orangeBtn,
              onPressed: () => addStep.value = AddStep.qWeighting,
              child: const Text(
                textAlign: TextAlign.center,
                Strings.startqWeighing,
                style: AppTextStyles.colorBtn,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            height: Sizes.bigBtnH,
            width: size.width * 0.9,
            child: ElevatedButton(
              style: AppButtonStyles.orangeBtn,
              onPressed: () => addStep.value = AddStep.cWeighting,
              child: const Text(
                textAlign: TextAlign.center,
                Strings.startcWeighing,
                style: AppTextStyles.colorBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
