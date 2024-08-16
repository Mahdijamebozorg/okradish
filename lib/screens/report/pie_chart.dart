import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/model/daily.dart';
import 'package:okradish/utils/calory.dart';

class MyPieChart extends StatelessWidget {
  final DailyEntry entry;
  const MyPieChart({required this.entry, super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      children: [
        // Diagram
        SizedBox(height: size.height * 0.15, child: PieDiagram(entry: entry)),

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
                _ItemRow(text: Strings.carbo, calory: entry.totalCarboCalory),
                const SizedBox(height: Sizes.medium),
                _ItemRow(
                    text: Strings.protein, calory: entry.totalProteinCalory),
                const SizedBox(height: Sizes.medium),
                _ItemRow(text: Strings.fat, calory: entry.totalFatCalory),
                const SizedBox(height: Sizes.medium),
                _ItemRow(text: Strings.fiber, calory: entry.totalFiberCalory),
                const SizedBox(height: Sizes.medium),
                _ItemRow(text: Strings.totalCal, calory: entry.totalCalories),
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
  final DailyEntry entry;
  const PieDiagram({required this.entry, super.key});

  @override
  State<PieDiagram> createState() => _PieDiagramState();
}

class _PieDiagramState extends State<PieDiagram> {
  var touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
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
                ? ((widget.entry.totalCarboCalory /
                            widget.entry.totalCalories) *
                        100)
                    .round()
                    .toString()
                : "",
            titleStyle: AppTextStyles.blackBtn,
            color: AppColors.trunks,
            value: widget.entry.totalCarboCalory / widget.entry.totalCalories,
            radius: touchedIndex == 0 ? 90 : 70,
          ),

          // Protein
          PieChartSectionData(
            title: touchedIndex == 1
                ? ((widget.entry.totalProteinCalory /
                            widget.entry.totalCalories) *
                        100)
                    .round()
                    .toString()
                : "",
            titleStyle: AppTextStyles.blackBtn,
            color: AppColors.primaryColor,
            value: widget.entry.totalProteinCalory / widget.entry.totalCalories,
            radius: touchedIndex == 1 ? 90 : 70,
          ),

          // Fat
          PieChartSectionData(
            title: touchedIndex == 2
                ? ((widget.entry.totalFatCalory / widget.entry.totalCalories) *
                        100)
                    .round()
                    .toString()
                : "",
            titleStyle: AppTextStyles.blackBtn,
            color: AppColors.orange,
            value: widget.entry.totalFatCalory / widget.entry.totalCalories,
            radius: touchedIndex == 2 ? 90 : 70,
          ),

          // Fiber
          PieChartSectionData(
            title: touchedIndex == 3
                ? ((widget.entry.totalFiberCalory /
                            widget.entry.totalCalories) *
                        100)
                    .round()
                    .toString()
                : "",
            titleStyle: AppTextStyles.blackBtn,
            color: AppColors.grey,
            value: widget.entry.totalFiberCalory / widget.entry.totalCalories,
            radius: touchedIndex == 3 ? 90 : 70,
          ),
        ],
      ),
    );
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
          parseCalory(calory),
          style: AppTextStyles.bodyMeduim,
        )
      ],
    );
  }
}
