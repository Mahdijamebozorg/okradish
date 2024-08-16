import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class ChooseDate extends StatelessWidget {
  ChooseDate({super.key});

  final Rx<Jalali> _chosenDate = Jalali.now().obs;
  final Rx<_DateType> _dateType = _DateType.custome.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const MyAppBar(title: Strings.chooseDate),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.small),
          child: AppCard(
            child: Obx(
              () => Column(
                children: [
                  // Date
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Options
                      DateOptions(
                        chosenDate: _chosenDate.value,
                        chooseDate: (date) {
                          _chosenDate.value = date;
                        },
                        setDateType: (type) {
                          _dateType.value = type;
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    Strings.date,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                  Text(
                                    "${_chosenDate.value.formatter.dd.toString()}/${_chosenDate.value.formatter.mN.toString()}/${_chosenDate.value.formatter.yyyy.toString()}",
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
                                  _chosenDate.value = value!;
                                },
                                selectableDayPredicate: (day) {
                                  if (day!.day == Jalali.now().day) {
                                    return true;
                                  }
                                  // enable
                                  if (_dateType.value != _DateType.custome) {
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
                      // Confirm
                      SizedBox(
                        width: 100,
                        height: Sizes.smallBtnH,
                        child: ElevatedButton(
                          style: AppButtonStyles.blackBtnStyle,
                          onPressed: () {
                            // TODO: retrun entry list based on date
                            late List<DailyEntry> output;
                            switch (_dateType.value) {
                              case _DateType.day:
                                output = [DummyData.dummyDay];
                                break;
                              case _DateType.custome:
                                output = [DummyData.dummyDay];
                                break;
                              case _DateType.week:
                                output = DummyData.dummyWeek;
                                break;
                              case _DateType.month:
                                output = DummyData.dummyMonth;
                                break;
                              default:
                                output = [DummyData.dummyDay];
                                break;
                            }
                            Navigator.pop(context, output);
                          },
                          child: const Text(
                            Strings.confirm,
                            style: AppTextStyles.blackBtn,
                          ),
                        ),
                      ),
                      const SizedBox(width: Sizes.medium),

                      // Cancel
                      SizedBox(
                        width: 100,
                        height: Sizes.smallBtnH,
                        child: ElevatedButton(
                          style: AppButtonStyles.textButtonBorder,
                          onPressed: () {
                            Navigator.pop(context, null);
                          },
                          child: const Text(
                            Strings.cancel,
                            style: AppTextStyles.borderBtn,
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
      ),
    );
  }
}

class DateOptions extends StatelessWidget {
  DateOptions({
    required this.chosenDate,
    required this.setDateType,
    required this.chooseDate,
    super.key,
  });

  final void Function(Jalali) chooseDate;
  final void Function(_DateType) setDateType;
  final Jalali chosenDate;

  static final RxInt index = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Today
          Container(
            color: index.value == 0 ? AppColors.trunks : AppColors.transparent,
            width: 90,
            height: Sizes.smallBtnH,
            child: TextButton(
              style: AppButtonStyles.textButtonBorder,
              onPressed: () {
                // to ensure updat
                chooseDate(Jalali.now().copy(
                  day: chosenDate.day - 1,
                ));
                chooseDate(Jalali.now());
                setDateType(_DateType.day);
                index.value = 0;
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
            color: index.value == 1 ? AppColors.trunks : AppColors.transparent,
            width: 90,
            height: Sizes.smallBtnH,
            child: TextButton(
              style: AppButtonStyles.textButtonBorder,
              onPressed: () {
                chooseDate(Jalali.now().copy(
                  day: Jalali.now().day - 1,
                ));
                setDateType(_DateType.day);
                index.value = 1;
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
            color: index.value == 2 ? AppColors.trunks : AppColors.transparent,
            width: 90,
            height: Sizes.smallBtnH,
            child: TextButton(
              style: AppButtonStyles.textButtonBorder,
              onPressed: () {
                setDateType(_DateType.week);
                chooseDate(Jalali.now().copy(
                  day: chosenDate.day - 1,
                ));
                chooseDate(Jalali.now());
                index.value = 2;
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
            color: index.value == 3 ? AppColors.trunks : AppColors.transparent,
            width: 90,
            height: Sizes.smallBtnH,
            child: TextButton(
              style: AppButtonStyles.textButtonBorder,
              onPressed: () {
                chooseDate(Jalali.now().copy(
                  day: Jalali.now().day - 7,
                ));
                setDateType(_DateType.week);
                index.value = 3;
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
            color: index.value == 4 ? AppColors.trunks : AppColors.transparent,
            width: 90,
            height: Sizes.smallBtnH,
            child: TextButton(
              style: AppButtonStyles.textButtonBorder,
              onPressed: () {
                chooseDate(Jalali.now().copy(
                  day: chosenDate.day - 1,
                ));
                chooseDate(Jalali.now());
                setDateType(_DateType.month);
                index.value = 4;
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
            color: index.value == 5 ? AppColors.trunks : AppColors.transparent,
            width: 90,
            height: Sizes.smallBtnH,
            child: TextButton(
              style: AppButtonStyles.textButtonBorder,
              onPressed: () {
                chooseDate(Jalali.now().copy(
                  month: Jalali.now().month - 1,
                ));
                setDateType(_DateType.month);
                index.value = 5;
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
            color: index.value == 6 ? AppColors.trunks : AppColors.transparent,
            width: 90,
            height: Sizes.bigBtnH,
            child: TextButton(
              style: AppButtonStyles.textButtonBorder,
              onPressed: () {
                chooseDate(Jalali.now().copy(
                  day: chosenDate.day - 1,
                ));
                chooseDate(Jalali.now());
                setDateType(_DateType.custome);
                index.value = 6;
              },
              child: const Text(
                Strings.customize,
                style: AppTextStyles.bodyMeduim,
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
