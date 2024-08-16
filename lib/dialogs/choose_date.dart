import 'package:flutter/material.dart';
import 'package:okradish/component/button_style.dart';
import 'package:okradish/component/text_style.dart';
import 'package:okradish/constants/colors.dart';
import 'package:okradish/constants/sizes.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/dummy_data.dart';
import 'package:okradish/model/daily.dart';
import 'package:okradish/widgets/app_card.dart';
import 'package:okradish/widgets/appbar.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

enum _DateType { day, week, month, custome }

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
                      chosenDate: _chosenDate,
                      chooseDate: (date) {
                        _chosenDate = date;
                        setState(() {});
                      },
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
                                  "${_chosenDate.formatter.dd.toString()}/${_chosenDate.formatter.mN.toString()}/${_chosenDate.formatter.yyyy.toString()}",
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: Sizes.tiny),

                          // Date
                          Expanded(
                            child: PCalendarDatePicker(
                              initialDate: Jalali.now(),
                              // TODO: Take fist date from ctrl
                              firstDate: Jalali.now().copy(month: 1),
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
                          // TODO: retrun entry list based on date
                          late List<DailyEntry> output;
                          switch (_dateType) {
                            case _DateType.day:
                              output = DummyData.dummyDay;
                              break;
                            case _DateType.custome:
                              output = DummyData.dummyDay;
                              break;
                            case _DateType.week:
                              output = DummyData.dummyWeek;
                              break;
                            case _DateType.month:
                              output = DummyData.dummyMonth;
                              break;
                            default:
                              output = DummyData.dummyDay;
                              break;
                          }
                          Navigator.of(context).pop(output);
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
    required this.chosenDate,
    required this.setDateType,
    required this.chooseDate,
    super.key,
  });

  final void Function(Jalali) chooseDate;
  final void Function(_DateType) setDateType;
  final Jalali chosenDate;

  @override
  State<DateOptions> createState() => _DateOptionsState();
}

class _DateOptionsState extends State<DateOptions> {
  int index = 6;

  Color optColor(int indx) {
    return index == indx ? AppColors.trunks.withOpacity(0.3) : AppColors.transparent;
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
              // to ensure updat
              widget.chooseDate(Jalali.now().copy(
                day: widget.chosenDate.day - 1,
              ));
              widget.chooseDate(Jalali.now());
              widget.setDateType(_DateType.day);
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
              widget.chooseDate(Jalali.now().copy(
                day: Jalali.now().day - 1,
              ));
              widget.setDateType(_DateType.day);
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
              widget.setDateType(_DateType.week);
              widget.chooseDate(Jalali.now().copy(
                day: widget.chosenDate.day - 1,
              ));
              widget.chooseDate(Jalali.now());
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
              widget.chooseDate(Jalali.now().copy(
                day: Jalali.now().day - 7,
              ));
              widget.setDateType(_DateType.week);
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
              widget.chooseDate(Jalali.now().copy(
                day: widget.chosenDate.day - 1,
              ));
              widget.chooseDate(Jalali.now());
              widget.setDateType(_DateType.month);
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
              widget.chooseDate(Jalali.now().copy(
                month: Jalali.now().month - 1,
              ));
              widget.setDateType(_DateType.month);
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
              widget.chooseDate(Jalali.now().copy(
                day: widget.chosenDate.day - 1,
              ));
              widget.chooseDate(Jalali.now());
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
