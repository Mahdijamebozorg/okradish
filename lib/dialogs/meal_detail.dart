import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/extention.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/colors.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/controllers/meal_controller.dart';
import 'package:OKRADISH/model/meal.dart';
import 'package:OKRADISH/widgets/app_card.dart';

class MealDetial extends StatelessWidget {
  final meal = Get.find<MealController>();
  MealDetial({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      child: GetBuilder<MealController>(
          id: 'meal',
          builder: (context) {
            return AppCard(
              child: Column(
                children: [
                  // Table
                  Expanded(
                    // Background
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: AppColors.greyBack,
                      ),
                      padding: const EdgeInsets.all(Sizes.small),
                      child: Column(
                        children: [
                          // Headings
                          const Padding(
                            padding: EdgeInsets.all(Sizes.medium),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 30),
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    Strings.food,
                                    style: AppTextStyles.borderBtn,
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    Strings.weight,
                                    style: AppTextStyles.borderBtn,
                                  ),
                                ),
                                SizedBox(width: 30),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    Strings.calory,
                                    style: AppTextStyles.borderBtn,
                                  ),
                                ),
                                SizedBox(width: 30),
                              ],
                            ),
                          ),
                          // List
                          Expanded(
                              child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: meal.foodItems.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: Sizes.tiny),
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  color: AppColors.white,
                                ),
                                padding: const EdgeInsets.all(Sizes.small),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Index
                                    SizedBox(
                                      width: 8,
                                      child: Text(
                                        (index + 1).toString().toPersian,
                                        style: AppTextStyles.borderBtn,
                                      ),
                                    ),
                                    const SizedBox(width: Sizes.medium),
                                    // Name
                                    Expanded(
                                      child: SizedBox(
                                        child: Text(
                                          meal.foodItems[index].food.name,
                                          style: AppTextStyles.borderBtn,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: Sizes.medium),
                                    // Weight
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        textDirection: TextDirection.ltr,
                                        meal.foodItems[index].weight
                                            .toString()
                                            .toPersian,
                                        style: AppTextStyles.borderBtn,
                                      ),
                                    ),
                                    const SizedBox(width: Sizes.medium),
                                    // Callory
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        textDirection: TextDirection.ltr,
                                        meal.foodItems[index].calories
                                            .toStringAsFixed(1)
                                            .toPersian,
                                        style: AppTextStyles.borderBtn,
                                      ),
                                    ),
                                    const SizedBox(width: Sizes.medium),
                                    // Remove
                                    SizedBox(
                                      width: 22,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        alignment: Alignment.center,
                                        onPressed: () {
                                          meal.removeFoodAt(index);
                                        },
                                        icon: const Center(
                                          child: Icon(
                                            Icons.delete_outline,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.medium),

                  // Overview
                  Container(
                    height: Sizes.bigBtnH,
                    width: size.width * 0.9,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: AppColors.darkGreen,
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: Sizes.medium),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Sum
                        const SizedBox(
                          width: 50,
                          child: Text(
                            Strings.sum,
                            style: AppTextStyles.highlight,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        // Weight
                        Expanded(
                          child: Text(
                            "${meal.totalWeight()}".toPersian,
                            style: AppTextStyles.highlight,
                          ),
                        ),
                        // Calories
                        Expanded(
                          child: Text(
                            meal.totalCalories().toStringAsFixed(1).toPersian,
                            style: AppTextStyles.highlight,
                          ),
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.medium),

                  // Back
                  SizedBox(
                    height: Sizes.smallBtnH,
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      style: AppButtonStyles.blackBtnStyle,
                      onPressed: () {
                        Get.back<Meal>(result: meal.meal);
                      },
                      child: const Text(
                        Strings.back,
                        style: AppTextStyles.blackBtn,
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.medium),
                ],
              ),
            );
          }),
    );
  }
}
