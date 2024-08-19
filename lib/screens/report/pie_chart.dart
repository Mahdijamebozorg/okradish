import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/controllers/summary_controller.dart';

class MyPieChart extends StatelessWidget {
  MyPieChart({super.key});

  final SummaryController summary = Get.find<SummaryController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        // Diagram
        SizedBox(height: size.height * 0.15, child: PieDiagram()),

        const SizedBox(height: Sizes.medium),

        // Indicators
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ColorIndicator(color: AppColors.black, text: Strings.carbo),
            ColorIndicator(
                color: AppColors.primaryColor, text: Strings.protein),
            ColorIndicator(color: AppColors.orange, text: Strings.fat),
            ColorIndicator(color: AppColors.trunks, text: Strings.fiber),
          ],
        ),

        const SizedBox(height: Sizes.large),

        // Items
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ItemRow(
                    text: Strings.carbo, calory: summary.totalCarboCalory()),
                const SizedBox(height: Sizes.medium),
                _ItemRow(
                    text: Strings.protein,
                    calory: summary.totalProteinCalory()),
                const SizedBox(height: Sizes.medium),
                _ItemRow(text: Strings.fat, calory: summary.totalFatCalory()),
                const SizedBox(height: Sizes.medium),
                _ItemRow(
                    text: Strings.fiber, calory: summary.totalFiberCalory()),
                const SizedBox(height: Sizes.medium),
                _ItemRow(
                    text: Strings.totalCal, calory: summary.totalCalories()),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class ColorIndicator extends StatelessWidget {
  final String text;
  final Color color;
  const ColorIndicator({required this.color, required this.text, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: Sizes.tiny),
        Text(text, style: AppTextStyles.bodySmall)
      ],
    );
  }
}

class PieDiagram extends StatefulWidget {
  const PieDiagram({super.key});

  @override
  State<PieDiagram> createState() => _PieDiagramState();
}

class _PieDiagramState extends State<PieDiagram> {
  final summary = Get.find<SummaryController>();
  var touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        id: "summary",
        init: summary,
        builder: (context) {
          return PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (!event.isInterestedForInteractions ||
                      pieTouchResponse == null ||
                      pieTouchResponse.touchedSection == null) {
                    touchedIndex = -1;
                    return;
                  }
                  touchedIndex =
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                  setState(() {});
                },
              ),
              borderData: FlBorderData(
                show: true,
              ),
              centerSpaceRadius: 0,
              sectionsSpace: 0,
              sections: [
                // Carbo
                PieChartSectionData(
                  title: touchedIndex == 0
                      ? ((summary.totalCarboCalory() / summary.totalCalories() +
                                  double.minPositive) *
                              100)
                          .round()
                          .toString()
                      : "",
                  titleStyle: AppTextStyles.blackBtn,
                  color: AppColors.trunks,
                  value: summary.totalCarboCalory() /
                      (summary.totalCalories() + double.minPositive),
                  radius: touchedIndex == 0 ? 90 : 70,
                ),

                // Protein
                PieChartSectionData(
                  title: touchedIndex == 1
                      ? ((summary.totalProteinCalory() /
                                  summary.totalCalories()) *
                              100)
                          .round()
                          .toString()
                      : "",
                  titleStyle: AppTextStyles.blackBtn,
                  color: AppColors.primaryColor,
                  value: summary.totalProteinCalory() /
                      (summary.totalCalories() + double.minPositive),
                  radius: touchedIndex == 1 ? 90 : 70,
                ),

                // Fat
                PieChartSectionData(
                  title: touchedIndex == 2
                      ? ((summary.totalFatCalory() /
                                  (summary.totalCalories() +
                                      double.minPositive)) *
                              100)
                          .round()
                          .toString()
                      : "",
                  titleStyle: AppTextStyles.blackBtn,
                  color: AppColors.orange,
                  value: summary.totalFatCalory() /
                      (summary.totalCalories() + double.minPositive),
                  radius: touchedIndex == 2 ? 90 : 70,
                ),

                // Fiber
                PieChartSectionData(
                  title: touchedIndex == 3
                      ? ((summary.totalFiberCalory() /
                                  summary.totalCalories()) *
                              100)
                          .round()
                          .toString()
                      : "",
                  titleStyle: AppTextStyles.blackBtn,
                  color: AppColors.grey,
                  value: summary.totalFiberCalory() /
                      (summary.totalCalories() + double.minPositive),
                  radius: touchedIndex == 3 ? 90 : 70,
                ),
              ],
            ),
            swapAnimationDuration: const Duration(milliseconds: 300),
          );
        });
  }
}

class _ItemRow extends StatelessWidget {
  final double calory;
  final String text;
  const _ItemRow({required this.text, required this.calory});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: AppTextStyles.bodyMeduim),
        Text(
          calory.toStringAsFixed(1),
          style: AppTextStyles.bodyMeduim,
        )
      ],
    );
  }
}
