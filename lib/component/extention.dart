import 'package:intl/intl.dart';
import 'package:OKRADISH/persian_datetime_picker-2.7.0/date/shamsi_date.dart';

extension IntExtention on int {
  String get separateWithComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

extension JalaliFormatter on DateTime {
  String get jalaliYmd {
    final jalali = Jalali.fromDateTime(this);
    return "${jalali.year}/${jalali.month}/${jalali.day}".toPersian;
  }
}

extension StringExtention on String {
  String get toPersian {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    String input = this;
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], farsi[i]);
    }
    return input;
  }
}
