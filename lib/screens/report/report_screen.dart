import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/dialogs/choose_date.dart';
import 'package:okradish/dialogs/edit_meal.dart';
import 'package:okradish/dummy_data.dart';
import 'package:okradish/model/daily.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/screens/report/bar_chart.dart';
import 'package:okradish/screens/report/pie_chart.dart';
import 'package:okradish/widgets/app_card.dart';
import 'package:okradish/widgets/appbar.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final RxInt _index = 0.obs;
  final RxList<DailyEntry> entries = RxList(DummyData.dummyMonth);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const MyAppBar(title: Strings.account),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.small),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // body
                Expanded(
                  child: AppCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Choose date
                            SizedBox(
                              height: Sizes.smallBtnH,
                              child: TextButton.icon(
                                onPressed: () {
                                  showDialog<List<DailyEntry>?>(
                                          context: context,
                                          builder: (context) => ChooseDate())
                                      .then((value) {
                                    if (value != null && value.isNotEmpty) {
                                      print(
                                          "carbo: ${value[0].totalCarboCalory}");
                                      print(
                                          "carbo: ${value[0].totalCarboCalory / value[0].totalCalories}");
                                      print(
                                          "pritein: ${value[0].totalProteinCalory}");
                                      print(
                                          "pritein: ${value[0].totalProteinCalory / value[0].totalCalories}");
                                      print(
                                          "fat: ${value[0].totalFatCalory}");
                                      print(
                                          "fat: ${value[0].totalFatCalory / value[0].totalCalories}");
                                      print("fiber: ${value[0].totalFiber}");
                                      print(
                                          "fiber: ${value[0].totalFiber / value[0].totalCalories}");
                                      print(
                                          "total: ${value[0].totalCalories}");
                                      entries.value = value;
                                    }
                                  });
                                },
                                label: const Text(
                                  Strings.chooseDate,
                                ),
                                icon: const Icon(
                                  Icons.date_range_outlined,
                                  color: AppColors.black,
                                  size: 14,
                                ),
                                style: AppButtonStyles.textButtonBorder,
                              ),
                            ),
    
                            // tab selector
                            _TabSelector(
                              index: _index.value,
                              setIndex: (int index) {
                                _index.value = index;
                              },
                            ),
                          ],
                        ),
    
                        const SizedBox(height: Sizes.medium),
    
                        // Charts
                        if (_index.value == 0)
                          Expanded(child: MyPieChart(entry: entries[0]))
                        else
                          Expanded(
                            // TODO: recive from ctrl
                            child: MyBarChart(entries: entries),
                          ),
                      ],
                    ),
                  ),
                ),
    
                const SizedBox(height: Sizes.medium),
    
                // edit meal Button
                Visibility(
                  visible: _index.value == 0,
                  child: SizedBox(
                    height: Sizes.bigBtnH,
                    width: size.width * 0.9,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          anchorPoint: Offset.infinite,
                          context: context,
                          builder: (context) {
                            // TODO: pass from ctrl
                            return EditMeal(DummyData.dummyFoods
                                .map((e) => Meal(
                                    id: e.id,
                                    foodItems: [
                                      FoodQuantity(
                                        food: e,
                                        id: e.id,
                                        weight: 100,
                                      )
                                    ],
                                    date: DateTime.now()))
                                .toList());
                          },
                        );
                      },
                      style: AppButtonStyles.highlightBtn,
                      child: const Text(
                        Strings.editMeal,
                        style: AppTextStyles.highlight,
                      ),
                    ),
                  ),
                ),
                //
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  const _TabSelector({
    required this.setIndex,
    required this.index,
  });

  final int index;
  final void Function(int index) setIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
        color: AppColors.greyBack,
      ),
      padding: const EdgeInsets.all(Sizes.tiny),
      child: Row(
        children: [
          SizedBox(
            height: Sizes.smallBtnH,
            child: ElevatedButton(
              onPressed: () => setIndex(0),
              style: index == 0
                  ? AppButtonStyles.blackBtnStyle
                  : AppButtonStyles.textButton,
              child: Text(
                Strings.public,
                style:
                    index == 0 ? AppTextStyles.blackBtn : AppTextStyles.textBtn,
              ),
            ),
          ),
          SizedBox(
            height: Sizes.smallBtnH,
            child: ElevatedButton(
              onPressed: () => setIndex(1),
              style: index == 1
                  ? AppButtonStyles.blackBtnStyle
                  : AppButtonStyles.textButton,
              child: Text(
                Strings.compare,
                style:
                    index == 1 ? AppTextStyles.blackBtn : AppTextStyles.textBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
