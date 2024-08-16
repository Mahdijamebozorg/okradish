import 'package:flutter/material.dart';
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

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _index = 0;
  List<DailyEntry> entries = DummyData.dummyDay;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const MyAppBar(title: Strings.account),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.small),
          child: Column(
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
                                        builder: (context) =>
                                            ChooseDate(key: UniqueKey()))
                                    .then((value) {
                                  if (value != null && value.isNotEmpty) {
                                    entries = value;
                                    setState(() {});
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
                            index: _index,
                            setIndex: (int index) {
                              _index = index;
                              setState(() {});
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: Sizes.medium),

                      // Charts
                      if (_index == 0)
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
                visible: _index == 0,
                child: SizedBox(
                  height: Sizes.bigBtnH,
                  width: size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<List<Meal>>(
                        anchorPoint: Offset.infinite,
                        context: context,
                        builder: (context) {
                          // TODO: pass from ctrl and sort
                          return EditMeal(
                            key: UniqueKey(),
                            entries
                                .map((entry) => entry.meals)
                                .toList()
                                .expand((x) => x)
                                .toList(),
                          );
                        },
                      ).then(
                        (editedMeals) {
                          if (editedMeals!.isEmpty) return;

                          // seacrch for edited entries
                          for (var meal in editedMeals) {
                            final entIndex = entries
                                .indexWhere((ent) => ent.meals.contains(meal));
                            final mealIndex = entries[entIndex]
                                .meals
                                .indexWhere((ml) => ml.id == meal.id);

                            if (meal.foodItems.isEmpty) {
                              entries[entIndex].meals.removeAt(mealIndex);
                            } else {
                              entries[entIndex] = entries[entIndex]
                                ..meals[mealIndex] = meal;
                            }
                          }
                          setState(() {});
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
