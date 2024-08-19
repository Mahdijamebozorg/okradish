import 'dart:math';

import 'package:flutter/material.dart';

class RandomUtills {
  String randomId() {
    return UniqueKey().toString();
  }

  int randomHour() {
    return Random(Random().nextInt(500)).nextInt(23);
  }

  int randomDay() {
    return Random(Random().nextInt(500)).nextInt(29) + 1;
  }
}
