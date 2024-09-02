import 'dart:math';
import 'package:uuid/uuid.dart';

class RandomUtills {
  String randomId() {
    return Uuid().v1();
  }

  int randomHour() {
    return Random(Random().nextInt(500)).nextInt(23);
  }

  int randomDay() {
    return Random(Random().nextInt(500)).nextInt(29) + 1;
  }
}
