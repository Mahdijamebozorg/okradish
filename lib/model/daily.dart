import 'package:hive/hive.dart';
import 'package:OKRADISH/model/meal.dart';
import 'package:OKRADISH/utils/random.dart';

part 'daily.g.dart';

@HiveType(typeId: 4)
class DailyEntry extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  List<Meal> meals;
  DailyEntry({
    required this.id,
    required this.meals,
    required this.date,
  });

  factory DailyEntry.dummy() {
    return DailyEntry(
        id: RandomUtills().randomId(), meals: [], date: DateTime.now());
  }
}
