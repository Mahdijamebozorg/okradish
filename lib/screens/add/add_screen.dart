import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/screens/add/init.dart';
import 'package:okradish/screens/add/weighting.dart';
import 'package:okradish/widgets/appbar.dart';

enum AddStep {
  init,
  weighting,
}

final _step = AddStep.init.obs;

class AddScreen extends StatelessWidget {
  const AddScreen({
    super.key,
  });

  /// Screen main widget
  Widget get currentWidget {
    if (_step.value == AddStep.init) {
      return Init((AddStep step) {
        _step.value = step;
      });
    } else {
      return Weighing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: const MyAppBar(title: Strings.addFoodTitle),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // weight
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  0.toString(),
                  style: AppTextStyles.weightNumber,
                ),
                const Positioned(
                  top: 0,
                  left: 0,
                  child: Text(Strings.gram, style: AppTextStyles.pageTitle),
                )
              ],
            ),
            // bases on step
            Obx(() => currentWidget),
          ],
        ),
      ),
    );
  }
}
