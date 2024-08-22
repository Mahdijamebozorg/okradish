import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DateUtills {
  DateUtills._();

  static void forEachDayInWeek(Function f, DateTime startDate) async {
    // if week
    for (var i = 0; i < 7; i++) {
      final date = startDate.add(Duration(days: i));
      await f(date);
    }
  }

  static void forEachDayInMonth(
      Function f, DateTime startDate, int monthLength) async {
    // if week
    for (var i = 1; i <= monthLength; i++) {
      final date = startDate.add(Duration(days: i));
      await f(date);
    }
  }

  static List<DateTime> weekDays(DateTime aDay) {
    // var date = Jalali.fromDateTime(aDay);
    List<DateTime> dates = [];
    final startOfWeek =
        aDay.copyWith(day: aDay.day - (Jalali.fromDateTime(aDay).weekDay - 1));

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      dates.add(date);
    }
    return dates;
  }

  static List<DateTime> monthDays(DateTime aDay) {
    List<DateTime> dates = [];
    var monthDay = Jalali.fromDateTime(aDay);
    final startOfMonth = monthDay.copy(day: 1);
    final daysInMonth = monthDay.monthLength;
    for (int i = 0; i < daysInMonth; i++) {
      final date = startOfMonth.toDateTime().add(Duration(days: i));
      dates.add(date);
    }
    return dates;
  }
}
