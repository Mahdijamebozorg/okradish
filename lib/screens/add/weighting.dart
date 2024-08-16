import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/dialogs/choose_food.dart';
import 'package:okradish/model/food.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/utils/calory.dart';
import 'package:okradish/widgets/app_card.dart';
import 'package:okradish/dialogs/meal_detail.dart';
import 'package:okradish/widgets/snackBar.dart';

class Weighing extends StatelessWidget {
  final _weight = 100.0.obs;
  final Rx<Meal> _meal = Meal.dummy().obs;
  final Rx<Food?> _selectedFood = Rx(null);

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
                () => (_selectedFood.value == null)
                    ? GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) => ChooseFood(),
                          ).then((food) => _selectedFood.value = food as Food?);
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
                        _selectedFood.value!.name,
                        style: AppTextStyles.bodyMeduim,
                      ),
              ),
              // add food to meal
              ElevatedButton(
                onPressed: () {
                  if (_selectedFood.value != null) {
                    // TODO: add controller
                    _meal.update(
                      (meal) => meal!.foodItems.add(
                        FoodQuantity(
                          id: "id",
                          food: _selectedFood.value!,
                          weight: _weight.value,
                        ),
                      ),
                    );
                    _selectedFood.value = null;
                  } else {
                    showSnackbar(
                      context,
                      const Text(
                        ErrorTexts.emptyMeal,
                        style: AppTextStyles.bodyMeduim,
                      ),
                    );
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
        AppCard(
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
                        Obx(
                          () => Text(
                            parseCalory(_meal.value.totalCalories),
                            textDirection: TextDirection.ltr,
                            style: AppTextStyles.bodyExtreme,
                          ),
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
                        if (_meal.value.foodItems.isEmpty) {
                          showSnackbar(
                            context,
                            const Text(
                              ErrorTexts.emptyMeal,
                              style: AppTextStyles.bodyMeduim,
                            ),
                          );
                        } else {
                          showDialog<Meal>(
                            context: context,
                            builder: (context) => MealDetial(meal: _meal.value),
                          ).then((meal) => _meal.update(
                                (val) => val!.foodItems = meal!.foodItems,
                              ));
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
                  onPressed: () {
                    //
                    if (_meal.value.foodItems.isEmpty) {
                      showSnackbar(
                        context,
                        const Text(
                          ErrorTexts.emptyMeal,
                          style: AppTextStyles.bodyMeduim,
                        ),
                      );
                    } else {
                      //
                    }
                  },
                  child: const Text(
                    textAlign: TextAlign.center,
                    Strings.finalizeMeal,
                    style: AppTextStyles.colorBtn,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
