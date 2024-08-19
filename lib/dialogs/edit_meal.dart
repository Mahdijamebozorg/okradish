import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/controllers/daily_controller.dart';
import 'package:okradish/controllers/meal_controller.dart';
import 'package:okradish/dialogs/meal_detail.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/widgets/app_card.dart';

class EditMeal extends StatelessWidget {
  EditMeal({super.key});
  final meals = Get.find<DailyController>();
  final RxInt selectedIndex = 0.obs;
  final List<String> editedMealsIds = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      child: GetBuilder<DailyController>(
          id: 'daily',
          init: meals,
          builder: (context) {
            return AppCard(
              child: Column(
                children: [
                  // Table
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: AppColors.greyBack,
                      ),
                      padding: const EdgeInsets.all(Sizes.tiny),
                      child: Column(
                        children: [
                          // Headings
                          const Padding(
                            padding: EdgeInsets.all(Sizes.medium),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 58),
                                // Date
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    Strings.date,
                                    style: AppTextStyles.borderBtn,
                                  ),
                                ),
                                SizedBox(width: 25),
                                // Time
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    Strings.hour,
                                    style: AppTextStyles.borderBtn,
                                  ),
                                ),
                                SizedBox(width: 25),
                                // Calory
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
                              itemCount: meals.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Sizes.tiny),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    selectedIndex.value = index;
                                  },
                                  child: Obx(() {
                                    return meals[index].foodItems.isEmpty
                                        ? Container()
                                        : Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0)),
                                              color:
                                                  selectedIndex.value == index
                                                      ? AppColors.orange
                                                      : AppColors.white,
                                            ),
                                            padding: const EdgeInsets.all(
                                                Sizes.medium),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Index
                                                SizedBox(
                                                  width: 25,
                                                  child: Text(
                                                    (index + 1).toString(),
                                                    style: AppTextStyles
                                                        .bodyMeduim,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Sizes.medium),
                                                // Date
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    DateFormat.yMd().format(
                                                        meals[index].date),
                                                    style:
                                                        AppTextStyles.borderBtn,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Sizes.medium),
                                                // Time
                                                SizedBox(
                                                  width: 45,
                                                  child: Text(
                                                    DateFormat.Hm().format(
                                                        meals[index].date),
                                                    style:
                                                        AppTextStyles.borderBtn,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Sizes.medium),
                                                // Calory
                                                SizedBox(
                                                  width: 80,
                                                  child: Text(
                                                    meals
                                                        .mealCtrl(index)
                                                        .totalCalories()
                                                        .toStringAsFixed(1),
                                                    style:
                                                        AppTextStyles.borderBtn,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                  }),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Sizes.medium),
                  // Edit
                  SizedBox(
                    height: Sizes.bigBtnH,
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () async {
                        // delete
                        Get.put(
                            MealController.value(meals[selectedIndex.value]));
                        Get.dialog<Meal>(
                          MealDetial(key: UniqueKey()),
                        ).then(
                          (meal) {
                            // note edited meal
                            if (!editedMealsIds.contains(meal!.id)) {
                              editedMealsIds.add(meal.id);
                            }
                            // update meal
                            // meals.removeAt(selectedIndex.value);
                            meals[selectedIndex.value] = meal;
                            Get.delete<MealController>();
                          },
                        );
                      },
                      style: AppButtonStyles.highlightBtn,
                      child: const Text(
                        Strings.chooseMeal,
                        style: AppTextStyles.highlight,
                      ),
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
                        Get.back(result: meals.where((meal) {
                          return editedMealsIds.contains(meal.id);
                        }));
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
