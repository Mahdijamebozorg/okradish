import 'package:flutter/material.dart';
import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/extention.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/colors.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/utils/date.dart';
import 'package:OKRADISH/widgets/app_card.dart';
import 'package:OKRADISH/widgets/appbar.dart';
// import 'package:persian_datetime_picker/persian_datetime_picker.dart' as date;
// import 'package:jalali_flutter_datepicker/jalali_flutter_datepicker.dart';
import 'package:OKRADISH/persian_datetime_picker-2.7.0/pcalendar_date_picker.dart';
import 'package:OKRADISH/persian_datetime_picker-2.7.0/date/shamsi_date.dart';

enum _DateType {
  yesterday,
  today,
  lastWeek,
  thisWeek,
  lastMonth,
  thisMonth,
  custome
}

class ChooseDate extends StatefulWidget {
  const ChooseDate({super.key});

  @override
  State<ChooseDate> createState() => _ChooseDateState();
}

class _ChooseDateState extends State<ChooseDate> {
  Jalali _chosenDate = Jalali.now();
  _DateType _dateType = _DateType.custome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const MyAppBar(title: Strings.chooseDate),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.small),
          child: AppCard(
            child: Column(
              children: [
                // Date
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Options
                    DateOptions(
                      setDateType: (type) {
                        _dateType = type;
                        setState(() {});
                      },
                    ),

                    const SizedBox(width: Sizes.medium),

                    // DatePicker
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Chosen date
                          Container(
                            width: 200,
                            height: Sizes.bigBtnH,
                            padding: const EdgeInsets.fromLTRB(
                              Sizes.medium,
                              0,
                              Sizes.medium,
                              0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                              border: Border.all(color: AppColors.black),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  Strings.date,
                                  style: AppTextStyles.bodySmall,
                                ),
                                Text(
                                  "${_chosenDate.formatter.dd.toString()}/${_chosenDate.formatter.mN.toString()}/${_chosenDate.formatter.yyyy.toString()}"
                                      .toPersian,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: Sizes.tiny),

                          // Date
                          Expanded(
                            child: PCalendarDatePicker(
                              initialDate: Jalali.now(),
                              firstDate: Jalali.now().copy(month: 1, day: 1),
                              lastDate: Jalali.now(),
                              onDateChanged: (Jalali? value) {
                                _chosenDate = value!;
                                setState(() {});
                              },
                              selectableDayPredicate: (day) {
                                if (day!.day == Jalali.now().day) {
                                  return true;
                                }
                                // enable
                                if (_dateType != _DateType.custome) {
                                  return false;
                                }
                                //
                                return true;
                              },
                              // disabledDayColor: AppColors.trunks,
                              // enabledDayColor: AppColors.white,
                              // footerIconColor: AppColors.white,
                              // footerTextStyle: AppTextStyles.blackBtn,
                              // selectedDayBackground: AppColors.orange,
                              // selectedDayColor: AppColors.white,
                              // todayColor: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
                const Divider(),

                const SizedBox(height: Sizes.medium),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel
                    SizedBox(
                      width: 100,
                      height: Sizes.smallBtnH,
                      child: ElevatedButton(
                        style: AppButtonStyles.textButtonBorder,
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: const Text(
                          Strings.cancel,
                          style: AppTextStyles.borderBtn,
                        ),
                      ),
                    ),
                    const SizedBox(width: Sizes.medium),
                    // Confirm
                    SizedBox(
                      width: 100,
                      height: Sizes.smallBtnH,
                      child: ElevatedButton(
                        style: AppButtonStyles.blackBtnStyle,
                        onPressed: () {
                          List<DateTime> dates = [];
                          switch (_dateType) {
                            case _DateType.yesterday:
                              {
                                dates.add(DateTime.now()
                                    .subtract(const Duration(days: 1)));
                              }
                              break;
                            case _DateType.today:
                              {
                                dates.add(DateTime.now());
                              }
                              break;
                            case _DateType.custome:
                              {
                                dates.add(_chosenDate.toDateTime());
                              }
                              break;
                            case _DateType.thisWeek:
                              {
                                dates.addAll(
                                    DateUtills.weekDays(DateTime.now()));
                              }
                              break;
                            case _DateType.lastWeek:
                              {
                                var lastWeek = DateTime.now()
                                    .subtract(const Duration(days: 7));
                                dates.addAll(DateUtills.weekDays(lastWeek));
                              }
                              break;

                            case _DateType.thisMonth:
                              {
                                dates.addAll(
                                  DateUtills.monthDays(DateTime.now()),
                                );
                              }

                            case _DateType.lastMonth:
                              {
                                final lastMonth = DateTime.now().subtract(
                                    Duration(days: Jalali.now().day + 1));
                                dates.addAll(DateUtills.monthDays(lastMonth));
                              }
                              break;
                            default:
                              break;
                          }
                          Navigator.of(context).pop(dates);
                        },
                        child: const Text(
                          Strings.confirm,
                          style: AppTextStyles.blackBtn,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateOptions extends StatefulWidget {
  const DateOptions({
    required this.setDateType,
    super.key,
  });

  final void Function(_DateType) setDateType;

  @override
  State<DateOptions> createState() => _DateOptionsState();
}

class _DateOptionsState extends State<DateOptions> {
  int index = 6;

  Color optColor(int indx) {
    return index == indx
        ? AppColors.trunks.withOpacity(0.3)
        : AppColors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Today
        Container(
          color: optColor(0),
          width: 90,
          height: Sizes.smallBtnH,
          child: TextButton(
            style: AppButtonStyles.textButtonBorder,
            onPressed: () {
              widget.setDateType(_DateType.today);
              index = 0;
              setState(() {});
            },
            child: const Text(
              Strings.tody,
              style: AppTextStyles.bodyMeduim,
              softWrap: true,
            ),
          ),
        ),

        const SizedBox(height: Sizes.tiny),

        // Yesterday
        Container(
          color: optColor(1),
          width: 90,
          height: Sizes.smallBtnH,
          child: TextButton(
            style: AppButtonStyles.textButtonBorder,
            onPressed: () {
              widget.setDateType(_DateType.yesterday);
              index = 1;
              setState(() {});
            },
            child: const Text(
              Strings.yesterday,
              style: AppTextStyles.bodyMeduim,
              softWrap: true,
            ),
          ),
        ),

        const SizedBox(height: Sizes.tiny),

        // This week
        Container(
          color: optColor(2),
          width: 90,
          height: Sizes.smallBtnH,
          child: TextButton(
            style: AppButtonStyles.textButtonBorder,
            onPressed: () {
              widget.setDateType(_DateType.thisWeek);
              index = 2;
              setState(() {});
            },
            child: const Text(
              Strings.thisWeek,
              style: AppTextStyles.bodyMeduim,
              softWrap: true,
            ),
          ),
        ),

        const SizedBox(height: Sizes.tiny),

        // last week
        Container(
          color: optColor(3),
          width: 90,
          height: Sizes.smallBtnH,
          child: TextButton(
            style: AppButtonStyles.textButtonBorder,
            onPressed: () {
              widget.setDateType(_DateType.lastWeek);
              index = 3;
              setState(() {});
            },
            child: const Text(
              Strings.lastWeek,
              style: AppTextStyles.bodyMeduim,
              softWrap: true,
            ),
          ),
        ),

        const SizedBox(height: Sizes.tiny),

        // This month
        Container(
          color: optColor(4),
          width: 90,
          height: Sizes.smallBtnH,
          child: TextButton(
            style: AppButtonStyles.textButtonBorder,
            onPressed: () {
              widget.setDateType(_DateType.thisMonth);
              index = 4;
              setState(() {});
            },
            child: const Text(
              Strings.thisMonth,
              style: AppTextStyles.bodyMeduim,
              softWrap: true,
            ),
          ),
        ),

        const SizedBox(height: Sizes.tiny),

        // Last month
        Container(
          color: optColor(5),
          width: 90,
          height: Sizes.smallBtnH,
          child: TextButton(
            style: AppButtonStyles.textButtonBorder,
            onPressed: () {
              widget.setDateType(_DateType.lastMonth);
              index = 5;
              setState(() {});
            },
            child: const Text(
              Strings.lastMonth,
              style: AppTextStyles.bodyMeduim,
              softWrap: true,
            ),
          ),
        ),

        const SizedBox(height: Sizes.tiny),

        // Custome
        Container(
          color: optColor(6),
          width: 90,
          height: Sizes.bigBtnH,
          child: TextButton(
            style: AppButtonStyles.textButtonBorder,
            onPressed: () {
              widget.setDateType(_DateType.custome);
              index = 6;
              setState(() {});
            },
            child: const Text(
              Strings.customize,
              style: AppTextStyles.bodyMeduim,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
