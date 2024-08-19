import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;
  @HiveField(2)
  final String username;
  @HiveField(3)
  final String phone;
  @HiveField(4)
  final String token;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.token = "",
  });
}
