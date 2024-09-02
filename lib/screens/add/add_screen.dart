import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:OKRADISH/component/extention.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/controllers/meal_controller.dart';
import 'package:OKRADISH/widgets/bluetooth.dart';
import 'package:OKRADISH/screens/add/init.dart';
import 'package:OKRADISH/screens/add/weighting.dart';
import 'package:OKRADISH/screens/home_screen.dart';
import 'package:OKRADISH/services/weighing_servce.dart';
import 'package:OKRADISH/widgets/appbar.dart';

enum AddStep { init, qWeighting, cWeighting }
var addStep = AddStep.init.obs;

class AddScreen extends StatefulWidget {
  AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final weightCtrl = Get.put(WeighingServce());

  @override
  void initState() {
    weightCtrl.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // on change page
    if (homeIndex != HomeScreenIndex.add) {
      addStep.value = AddStep.init;
      Get.delete<MealController>();
    }
    log('----- AddScreen rebuilt');
    return SafeArea(
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
                  child: Obx(
                    () => weightCtrl.device.value == null
                        ? const BluetoothDialog()
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              // Weight
                              Padding(
                                padding: const EdgeInsets.all(Sizes.small),
                                child: Text(
                                  weightCtrl.weight.value.toString().toPersian,
                                  style: AppTextStyles.weightNumber,
                                ),
                              ),

                              // Gram
                              const Positioned(
                                top: 0,
                                left: 0,
                                child: Text(Strings.gram,
                                    style: AppTextStyles.gram),
                              )
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: Sizes.large,
              ),
              // bases on step
              SingleChildScrollView(
                  child: Obx(
                () => addStep == AddStep.init ? const Init() : const Weighing(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}