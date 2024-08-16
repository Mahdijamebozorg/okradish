String parseCalory(double calory) {
  var digits = calory.toString();

  // for web
  if (!digits.contains('.')) {
    digits += ".0";
  } else {
    // 0.1 calory precision
    final dot = digits.indexOf('.');
    digits = digits.substring(0, dot + 2);
  }

  if (digits.length >= 6) {
    String base = '';
    String rest = '';
    if (digits.length == 6) {
      base = digits[0];
    } else {
      base = digits.substring(0, digits.length - 5);
    }
    rest = digits.substring(digits.length - 5, digits.length - 3);

    return "$base.${rest}Kcal";
  } else {
    return "${digits}cal";
  }
}
