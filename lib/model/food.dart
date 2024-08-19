import 'package:hive/hive.dart';
import 'package:okradish/utils/random.dart';

part 'food.g.dart';

@HiveType(typeId: 1)
class Food extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double carboPerGram;
  @HiveField(3)
  final double proteinPerGram;
  @HiveField(4)
  final double fatPerGram;
  @HiveField(5)
  final double fibersPerGram;

  Food({
    required this.id,
    required this.name,
    required this.carboPerGram,
    required this.proteinPerGram,
    required this.fatPerGram,
    required this.fibersPerGram,
  });

  factory Food.dummy() {
    return Food(
      id: RandomUtills().randomId(),
      name: 'name',
      carboPerGram: 0,
      fatPerGram: 0,
      fibersPerGram: 0,
      proteinPerGram: 0,
    );
  }
}
