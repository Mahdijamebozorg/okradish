import 'package:OKRADISH/utils/random.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/extention.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/services/data_service.dart';
import 'package:OKRADISH/controllers/meal_controller.dart';
import 'package:OKRADISH/dialogs/choose_food.dart';
import 'package:OKRADISH/model/food.dart';
import 'package:OKRADISH/model/meal.dart';
import 'package:OKRADISH/model/quantity.dart';
import 'package:OKRADISH/screens/add/add_screen.dart';
import 'package:OKRADISH/services/weighing_servce.dart';
import 'package:OKRADISH/widgets/app_card.dart';
import 'package:OKRADISH/dialogs/meal_detail.dart';
import 'package:OKRADISH/widgets/snackbar.dart';

class Weighing extends StatelessWidget {
  final void Function(AddStep step) changeState;
  Weighing(this.changeState, this.selectedFood, {super.key});

  final weighingService = Get.find<WeighingServce>();

  final mealCtrl = Get.isRegistered<MealController>()
      ? Get.find<MealController>()
      : Get.put(MealController.create());

  final Rx<Food?> selectedFood;
  final RxBool waiting = false.obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        // Search
        AppCard(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => (selectedFood.value == null)
                    ? GestureDetector(
                        onTap: () async {
                          Get.dialog<Food>(
                            const ChooseFood(),
                          ).then(
                            (food) => selectedFood.value = food,
                          );
                        },
                        child: const Hero(
                          tag: "search",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.search, size: 14),
                              SizedBox(width: Sizes.tiny),
                              Text(Strings.search, style: AppTextStyles.search),
                            ],
                          ),
                        ),
                      )
                    : Text(
                        selectedFood.value!.name,
                        style: AppTextStyles.bodyMeduim,
                      ),
              ),
              // add food to meal
              ElevatedButton(
                onPressed: () {
                  // if no food selcted
                  if (selectedFood.value == null) {
                    showSnackbar(context, ErrorTexts.emptyMeal);
                    return;
                  }
                  // if weigher is not connected properly
                  else if (weighingService.weight.value <= 0) {
                    showSnackbar(context, ErrorTexts.weighterError);
                    return;
                  } else {
                    mealCtrl.add(
                      FoodQuantity(
                        id: RandomUtills().randomId(),
                        food: selectedFood.value!,
                        weight: weighingService.weight.value.toDouble(),
                      ),
                    );
                    selectedFood.value = null;
                  }
                },
                style: AppButtonStyles.blackBtnStyle,
                child: const Text(
                  Strings.addFood,
                  style: AppTextStyles.blackBtn,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: Sizes.medium),

        // Meal status
        GetBuilder<MealController>(
            id: "meal",
            init: mealCtrl,
            builder: (ctrl) {
              return AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                Strings.totalCal,
                                style: AppTextStyles.bodyMeduim,
                              ),
                              const SizedBox(height: Sizes.medium),
                              Text(
                                mealCtrl
                                    .totalCalories()
                                    .toStringAsFixed(1)
                                    .toPersian,
                                textDirection: TextDirection.ltr,
                                style: AppTextStyles.bodyExtreme,
                              ),
                            ],
                          ),
                        ),
                        // show details
                        SizedBox(
                          height: Sizes.smallBtnH,
                          child: ElevatedButton(
                            style: AppButtonStyles.highlightBtn,
                            onPressed: () {
                              if (mealCtrl.foodItems.isEmpty) {
                                showSnackbar(context, ErrorTexts.emptyMeal);
                              } else {
                                Get.dialog<Meal>(
                                  MealDetial(key: UniqueKey()),
                                ).then((meal) =>
                                    mealCtrl.foodItems = meal!.foodItems);
                              }
                            },
                            child: const Text(
                              Strings.details,
                              style: AppTextStyles.smallHighlight,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),

                    // Save meal
                    SizedBox(
                      height: Sizes.bigBtnH,
                      width: size.width * 0.9,
                      child: ElevatedButton(
                        style: AppButtonStyles.orangeBtn,
                        onPressed: () async {
                          //
                          if (mealCtrl.foodItems.isEmpty) {
                            showSnackbar(context, ErrorTexts.emptyMeal);
                          } else {
                            //
                            final data = Get.find<DataSevice>();
                            waiting.value = true;
                            await data.addMeal(mealCtrl.meal);
                            waiting.value = false;
                            changeState(AddStep.init);
                            showSnackbar(context, Strings.saveMeal);
                          }
                        },
                        child: waiting.value
                            ? const Center(child: CircularProgressIndicator())
                            : const Text(
                                textAlign: TextAlign.center,
                                Strings.finalizeMeal,
                                style: AppTextStyles.colorBtn,
                              ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ],
    );
  }
}
