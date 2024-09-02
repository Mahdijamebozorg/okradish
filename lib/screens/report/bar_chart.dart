import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/extention.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/colors.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/controllers/daily_controller.dart';
import 'package:OKRADISH/controllers/meal_controller.dart';
import 'package:OKRADISH/controllers/summary_controller.dart';
import 'package:OKRADISH/model/daily.dart';
import 'package:OKRADISH/model/meal.dart';
import 'package:OKRADISH/persian_datetime_picker-2.7.0/date/shamsi_date.dart';

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

extension _EnumtoString on _Nutrient {
  String get toPersian {
    switch (this) {
      case _Nutrient.carbo:
        return Strings.carbo;
      case _Nutrient.protein:
        return Strings.protein;
      case _Nutrient.fat:
        return Strings.fat;
      case _Nutrient.fiber:
        return Strings.fiber;
      case _Nutrient.calory:
        return Strings.totalCal;
      default:
        return Strings.totalCal;
    }
  }
}

class MyBarChart extends StatefulWidget {
  MyBarChart({super.key});

  @override
  State<StatefulWidget> createState() => MyBarChartState();
}

class MyBarChartState extends State<MyBarChart> {
  static var nutrient = _Nutrient.calory;
  final summary = Get.find<SummaryController>(tag: 'report');

  _BarType get _barType {
    if (summary.entries.length == 1) {
      return _BarType.daily;
    } else if (summary.entries.length == 7) {
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
        return summary.entries.length;
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
          return Column(
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
                            rod.toY.toStringAsFixed(1).toPersian,
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
                            if (_barType != _BarType.weekly) {
                              if (!(value.round() % 6 == 0 ||
                                  value.round() == itemsLen - 1)) {}
                            }
                            if (!(value.round() % 6 == 0 ||
                                    (value.round() == itemsLen - 1 &&
                                        _barType != _BarType.monthly)) &&
                                _barType != _BarType.weekly) {
                              return Container();
                            }
                            return Text(
                              _barType == _BarType.daily
                                  ? value.round().toString().toPersian
                                  : (value.round() + 1).toString().toPersian,
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
                            value == meta.max ? "" : meta.formattedValue.toPersian,
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
                    ),

                    //
                    borderData: FlBorderData(show: false),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 500),
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
                        builder: (context) =>
                            _ChooseNutrient(key: UniqueKey())).then((index) {
                      nutrient = index!.toNutrient;
                      setState(() {});
                    });
                  },
                  style: AppButtonStyles.textButtonBorder,
                  child: Text(
                    nutrient.toPersian,
                    style: AppTextStyles.bodyMeduim,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<BarChartGroupData> barGroups(
      _BarType type, double barsWidth, double barsSpace) {
    double getMealNutrien(Meal meal) {
      final mealCtrl = MealController.value(meal);
      switch (nutrient) {
        case _Nutrient.carbo:
          return mealCtrl.totalCarboCalory();
        case _Nutrient.protein:
          return mealCtrl.totalProteinCalory();
        case _Nutrient.fat:
          return mealCtrl.totalFatCalory();
        case _Nutrient.fiber:
          return mealCtrl.totalFiberCalory();
        case _Nutrient.calory:
          return mealCtrl.totalCalories();
        default:
          return mealCtrl.totalCalories();
      }
    }

    double getEntryNutrien(DailyEntry daily) {
      final dailyCtrl = DailyController.value(daily);
      switch (nutrient) {
        case _Nutrient.carbo:
          return dailyCtrl.totalCarboCalory();
        case _Nutrient.protein:
          return dailyCtrl.totalProteinCalory();
        case _Nutrient.fat:
          return dailyCtrl.totalFatCalory();
        case _Nutrient.fiber:
          return dailyCtrl.totalFiberCalory();
        case _Nutrient.calory:
          return dailyCtrl.totalCalories();
        default:
          return dailyCtrl.totalCalories();
      }
    }

    return List.generate(
      type == _BarType.daily
          ? 24
          : type == _BarType.weekly
              ? 7
              : 31,
      (group) {
        double barValue = 0;

        // Daily
        if (type == _BarType.daily) {
          final hourMeals = summary.entries[0].meals
              .where((meal) => meal.date.hour == group)
              .toList();
          for (var meal in hourMeals) {
            barValue += getMealNutrien(meal);
          }
        }

        // Monthly
        else if (type == _BarType.monthly) {
          final dayEntry = summary.entries
              .where((meal) => Jalali.fromDateTime(meal.date).day == group + 1)
              .toList();
          for (var daily in dayEntry) {
            barValue += getEntryNutrien(daily);
          }
        }

        // Weekly
        else {
          final dayEntry = summary.entries
              .where(
                  (meal) => Jalali.fromDateTime(meal.date).weekDay == group + 1)
              .toList();
          for (var daily in dayEntry) {
            barValue += getEntryNutrien(daily);
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
  const _ChooseNutrient({super.key});
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
              ),
            ),
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
              ),
            ),
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
              ),
            ),
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
              ),
            ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
