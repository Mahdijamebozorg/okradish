import 'package:intl/intl.dart';

extension IntExtention on int {
  String get separateWithComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
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
