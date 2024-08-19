import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/controllers/meal_controller.dart';
import 'package:okradish/model/food.dart';
import 'package:okradish/screens/add/init.dart';
import 'package:okradish/screens/add/weighting.dart';
import 'package:okradish/screens/home_screen.dart';
import 'package:okradish/services/weighing_servce.dart';
import 'package:okradish/widgets/appbar.dart';

enum AddStep {
  init,
  weighting,
}

var _step = AddStep.init;

class AddScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  AddScreen({
    super.key,
  });

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  // TODO: for performance, it's better to not put it
  final weightCtrl = Get.put(WeighingServce());
  final Rx<Food?> selectedFood = Rx(null);
  final wKey = GlobalKey();

  /// Screen main widget
  Widget get currentWidget {
    if (_step == AddStep.init) {
      return Init((AddStep step) {
        _step = step;
        selectedFood.value = null;
        setState(() {});
      });
    } else {
      // Don't try to understand (:
      return Weighing(
          (AddStep step) {
            _step = step;
            setState(() {});
          },
          selectedFood,
          key: wKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    // on change page
    if (homeIndex != HomeScreenIndex.add) {
      setState(() {
        _step = AddStep.init;
        Get.delete<MealController>();
      });
    }
    log('----- AddScreen rebuilt');
    return Visibility(
      visible: MediaQuery.viewInsetsOf(context).bottom < 10,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: const MyAppBar(title: Strings.addFoodTitle),
          body: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // weight
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GetX<WeighingServce>(
                            init: weightCtrl,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(Sizes.small),
                                child: Text(
                                  weightCtrl.weight.toString(),
                                  style: AppTextStyles.weightNumber,
                                ),
                              );
                            }),
                        // Gram
                        const Positioned(
                          top: 0,
                          left: 0,
                          child: Text(Strings.gram, style: AppTextStyles.gram),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: Sizes.large,
                ),
                // bases on step
                SingleChildScrollView(child: currentWidget),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
