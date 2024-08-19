import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/controllers/data_controller.dart';
import 'package:okradish/controllers/meal_controller.dart';
import 'package:okradish/dialogs/choose_food.dart';
import 'package:okradish/model/food.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/model/quantity.dart';
import 'package:okradish/screens/add/add_screen.dart';
import 'package:okradish/services/weighing_servce.dart';
import 'package:okradish/widgets/app_card.dart';
import 'package:okradish/dialogs/meal_detail.dart';
import 'package:okradish/widgets/snackbar.dart';

class Weighing extends StatelessWidget {
  final void Function(AddStep step) changeState;
  final weighingService = Get.find<WeighingServce>();

  final mealCtrl = Get.put(MealController.create());

  final Rx<Food?> selectedFood = Rx(null);

  final RxBool waiting = false.obs;

  Weighing(this.changeState, {super.key});

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
                          showDialog<Food>(
                            context: context,
                            builder: (context) => const ChooseFood(),
                          ).then((food) => selectedFood.value = food);
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
                  if (selectedFood.value != null) {
                    // TODO: add controller
                    mealCtrl.add(
                      FoodQuantity(
                        id: "id",
                        food: selectedFood.value!,
                        weight: weighingService.weight.value,
                      ),
                    );
                    selectedFood.value = null;
                  } else {
                    getSnackBar(ErrorTexts.emptyMeal);
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
            builder: (context) {
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
                                mealCtrl.totalCalories().toStringAsFixed(1),
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
                                getSnackBar(ErrorTexts.emptyMeal);
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
                            getSnackBar(ErrorTexts.emptyMeal);
                          } else {
                            //
                            final dataCtrl = Get.find<DataController>();
                            waiting.value = true;
                            await dataCtrl.addMeal(mealCtrl.meal);
                            waiting.value = false;
                            changeState(AddStep.init);
                            getSnackBar(Strings.saveMeal);
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
