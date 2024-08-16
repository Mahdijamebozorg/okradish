import 'package:flutter/material.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/utils/calory.dart';
import 'package:okradish/widgets/app_card.dart';

class MealDetial extends StatefulWidget {
  final Meal meal;
  const MealDetial({required this.meal, super.key});

  @override
  State<MealDetial> createState() => _MealDetialState();
}

class _MealDetialState extends State<MealDetial> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
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
                          width: 50,
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
                        SizedBox(width: 50),
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
                    itemCount: widget.meal.foodItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: Sizes.tiny),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: AppColors.white,
                        ),
                        padding: const EdgeInsets.all(Sizes.small),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Index
                            SizedBox(
                              width: 8,
                              child: Text(
                                (index + 1).toString(),
                                style: AppTextStyles.borderBtn,
                              ),
                            ),
                            const SizedBox(width: Sizes.medium),
                            // Name
                            Expanded(
                              child: Text(
                                widget.meal.foodItems[index].food.name,
                                style: AppTextStyles.borderBtn,
                              ),
                            ),
                            const SizedBox(width: Sizes.medium),
                            // Weight
                            SizedBox(
                              width: 60,
                              child: Text(
                                textDirection: TextDirection.ltr,
                                "${widget.meal.foodItems[index].weight.toString()}g",
                                style: AppTextStyles.borderBtn,
                              ),
                            ),
                            const SizedBox(width: Sizes.medium),
                            // Callory
                            SizedBox(
                              width: 80,
                              child: Text(
                                textDirection: TextDirection.ltr,
                                parseCalory(
                                    widget.meal.foodItems[index].calories),
                                style: AppTextStyles.borderBtn,
                              ),
                            ),
                            const SizedBox(width: Sizes.medium),
                            // Remove
                            SizedBox(
                              width: 32,
                              child: IconButton(
                                alignment: Alignment.center,
                                onPressed: () {
                                  setState(() {
                                    widget.meal.foodItems.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.delete_outline),
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
            padding: const EdgeInsets.symmetric(horizontal: Sizes.medium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 30),
                const SizedBox(
                  width: 50,
                  child: Text(
                    Strings.sum,
                    style: AppTextStyles.highlight,
                  ),
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  width: 50,
                  child: Text(
                    "${widget.meal.totalWeight}g",
                    style: AppTextStyles.highlight,
                  ),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  width: 100,
                  child: Text(
                    parseCalory(widget.meal.totalCalories),
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
                Navigator.pop(context, widget.meal);
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
  }
}
