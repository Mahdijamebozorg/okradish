import 'package:OKRADISH/model/daily.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/extention.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/colors.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/controllers/daily_controller.dart';
import 'package:OKRADISH/dialogs/meal_detail.dart';
import 'package:OKRADISH/model/meal.dart';
import 'package:OKRADISH/widgets/app_card.dart';

class MealsDetail extends StatelessWidget {
  MealsDetail({required this.meals, super.key});
  final List<Meal> meals;
  final RxInt selectedIndex = 0.obs;
  final List<String> editedMealsIds = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: false,
      child: GetBuilder<DailyController>(
          key: UniqueKey(),
          id: 'daily',
          init: DailyController.value(DailyEntry.today()..meals = meals),
          builder: (daily) {
            daily.sortMeals();
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Date
                                SizedBox(width: 25),
                                const SizedBox(width: Sizes.medium),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          Strings.date,
                                          style: AppTextStyles.borderBtn,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      // Time
                                      SizedBox(
                                        width: 45,
                                        child: Text(
                                          Strings.hour,
                                          style: AppTextStyles.borderBtn,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      // Calory
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          Strings.calory,
                                          style: AppTextStyles.borderBtn,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // List
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: daily.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: Sizes.tiny),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  key: UniqueKey(),
                                  onTap: () {
                                    selectedIndex.value = index;
                                  },
                                  child: daily[index].foodItems.isEmpty
                                      ? Container()
                                      : Obx(
                                          () => Container(
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
                                                    (index + 1)
                                                        .toString()
                                                        .toPersian,
                                                    style: AppTextStyles
                                                        .bodyMeduim,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width: Sizes.medium),
                                                Expanded(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Date
                                                      SizedBox(
                                                        width: 80,
                                                        child: Text(
                                                          daily[index]
                                                              .date
                                                              .jalaliYmd,
                                                          style: AppTextStyles
                                                              .borderBtn,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      // Time
                                                      SizedBox(
                                                        width: 45,
                                                        child: Text(
                                                          DateFormat.Hm()
                                                              .format(
                                                                  daily[index]
                                                                      .date)
                                                              .toString()
                                                              .toPersian,
                                                          style: AppTextStyles
                                                              .borderBtn,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                      // Calory
                                                      SizedBox(
                                                        width: 60,
                                                        child: Text(
                                                          daily
                                                              .mealCtrl(index)
                                                              .totalCalories()
                                                              .toStringAsFixed(
                                                                  1)
                                                              .toPersian,
                                                          style: AppTextStyles
                                                              .borderBtn,
                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
                        Get.dialog<Meal>(
                          MealDetial(
                            meal: daily[selectedIndex.value],
                            key: UniqueKey(),
                          ),
                        ).then(
                          (meal) {
                            // note edited meal
                            if (!editedMealsIds.contains(meal!.id)) {
                              editedMealsIds.add(meal.id);
                            }
                            // update meal
                            daily[selectedIndex.value] = meal;
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
                        Get.back(
                          result: daily.where(
                            (meal) => editedMealsIds.contains(meal.id),
                          ),
                        );
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
