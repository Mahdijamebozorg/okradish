import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/model/daily.dart';
import 'package:okradish/model/meal.dart';
import 'package:okradish/utils/calory.dart';

enum _Nutrient { carbo, protein, fat, fiber, calory }

enum _BarType { daily, monthly, weekly }

extension _EnumFromIndex on int {
  _Nutrient get toNutrient {
    switch (this) {
      case 0:
        return _Nutrient.carbo;
      case 1:
        return _Nutrient.protein;
      case 2:
        return _Nutrient.fat;
      case 3:
        return _Nutrient.fiber;
      case 4:
        return _Nutrient.calory;
      default:
        return _Nutrient.calory;
    }
  }
}


// Barchart
class MyBarChart extends StatefulWidget {
  final List<DailyEntry> entries;
  const MyBarChart({required this.entries, super.key});

  @override
  State<StatefulWidget> createState() => MyBarChartState();
}

class MyBarChartState extends State<MyBarChart> {
  final Rx<_Nutrient> _nutrient = _Nutrient.carbo.obs;

  _BarType get _barType {
    if (widget.entries.length == 1) {
      return _BarType.daily;
    } else if (widget.entries.length == 7) {
      return _BarType.weekly;
    } else {
      return _BarType.monthly;
    }
  }

  int get itemsLen {
    switch (_barType) {
      case _BarType.daily:
        return 24;
      case _BarType.weekly:
        return 7;
      case _BarType.monthly:
        return 30;
      default:
        return widget.entries.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barsSpace = (constraints.maxWidth / itemsLen) * 0.05;
          final barsWidth = (constraints.maxWidth / itemsLen) * 0.85;

          // update bases on seleceted nutrient
          return Obx(
            () => Column(
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) => AppColors.greyBack,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              parseCalory(rod.toY),
                              AppTextStyles.bodySmall,
                            );
                          },
                        ),
                      ),
                      barGroups: barGroups(
                        _barType,
                        barsWidth,
                        barsSpace,
                      ),

                      //
                      titlesData: FlTitlesData(
                        show: true,

                        // bellow the chart
                        bottomTitles: AxisTitles(
                          drawBelowEverything: false,
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (!(value.round() % 6 == 0 ||
                                      value.round() == itemsLen - 1) &&
                                  _barType != _BarType.weekly) {
                                return Container();
                              }
                              return Text(
                                _barType == _BarType.daily
                                    ? value.round().toString()
                                    : (value.round() + 1).toString(),
                                style: AppTextStyles.bodySmall,
                              );
                            },
                          ),
                        ),

                        // left of chart
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: (value, meta) => Text(
                              value == meta.max ? "" : meta.formattedValue,
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),

                      //

                      gridData: FlGridData(
                        show: true,
                        // checkToShowHorizontalLine: (value) => value % 10 == 0,
                        getDrawingHorizontalLine: (value) => const FlLine(
                          color: AppColors.trunks,
                          strokeWidth: 0.3,
                        ),
                        // TODO: fix vertical lines
                        // checkToShowVerticalLine: (value) =>
                        //     (value % 6 == 0 || value == itemsLen - 1),
                        // getDrawingVerticalLine: (value) {
                        //   return const FlLine(
                        //     color: AppColors.trunks,
                        //     strokeWidth: 0.3,
                        //   );
                        // },
                      ),

                      //
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.small),
                SizedBox(
                  height: Sizes.smallBtnH,
                  width: MediaQuery.sizeOf(context).width * 0.9,
                  child: TextButton(
                    onPressed: () {
                      showDialog<int>(
                              context: context,
                              builder: (context) => _ChooseNutrient())
                          .then((index) => _nutrient.value = index!.toNutrient);
                    },
                    style: AppButtonStyles.textButtonBorder,
                    child: const Text(
                      Strings.chooseD,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> barGroups(
      _BarType type, double barsWidth, double barsSpace) {
    double getMealNutrien(Meal meal) {
      switch (_nutrient.value) {
        case _Nutrient.carbo:
          return meal.totalCarboCalory;
        case _Nutrient.protein:
          return meal.totalProteinCalory;
        case _Nutrient.fat:
          return meal.totalFatCalory;
        case _Nutrient.fiber:
          return meal.totalFiberCalory;
        case _Nutrient.calory:
          return meal.totalCalories;
        default:
          return meal.totalCalories;
      }
    }

    double getEntryNutrien(DailyEntry entry) {
      switch (_nutrient.value) {
        case _Nutrient.carbo:
          return entry.totalCarboCalory;
        case _Nutrient.protein:
          return entry.totalProteinCalory;
        case _Nutrient.fat:
          return entry.totalFatCalory;
        case _Nutrient.fiber:
          return entry.totalFiberCalory;
        case _Nutrient.calory:
          return entry.totalCalories;
        default:
          return entry.totalCalories;
      }
    }

    return List.generate(
      type == _BarType.daily
          ? 24
          : type == _BarType.weekly
              ? 7
              : 30,
      (group) {
        double barValue = 0;

        // Daily
        if (type == _BarType.daily) {
          final hourMeals = widget.entries[0].meals
              .where((meal) => meal.date.hour == group)
              .toList();
          for (var meal in hourMeals) {
            barValue += getMealNutrien(meal);
          }
        }

        // Monthly
        else if (type == _BarType.monthly || type == _BarType.weekly) {
          final dayEntry =
              widget.entries.where((meal) => meal.date.day == group).toList();
          for (var entry in dayEntry) {
            barValue += getEntryNutrien(entry);
          }
        }

        return BarChartGroupData(
          x: group,
          barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
              toY: barValue,
              gradient: AppColors.lineChartGrad,
              borderRadius: BorderRadius.zero,
              width: barsWidth,
            )
          ],
        );
      },
    );
  }
}

// dialog
class _ChooseNutrient extends StatelessWidget {
  final RxInt index = 0.obs;
  @override
  Widget build(BuildContext context) {
    void onPressed(int value) {
      Navigator.pop(context, value);
    }

    return Dialog(
      child: Container(
          height: 300,
          width: 200,
          color: AppColors.white,
          padding: const EdgeInsets.all(Sizes.medium),
          child: Column(
            children: [
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => onPressed(0),
                  style: AppButtonStyles.textButton,
                  child: const Text(
                    Strings.carbo,
                    style: AppTextStyles.bodyMeduim,
                  ),
                ),
              )),
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => onPressed(1),
                  style: AppButtonStyles.textButton,
                  child: const Text(
                    Strings.protein,
                    style: AppTextStyles.bodyMeduim,
                  ),
                ),
              )),
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => onPressed(2),
                  style: AppButtonStyles.textButton,
                  child: const Text(
                    Strings.fat,
                    style: AppTextStyles.bodyMeduim,
                  ),
                ),
              )),
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => onPressed(3),
                  style: AppButtonStyles.textButton,
                  child: const Text(
                    Strings.fiber,
                    style: AppTextStyles.bodyMeduim,
                  ),
                ),
              )),
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => onPressed(4),
                  style: AppButtonStyles.textButton,
                  child: const Text(
                    Strings.totalCal,
                    style: AppTextStyles.bodyMeduim,
                  ),
                ),
              )),
            ],
          )),
    );
  }
}
