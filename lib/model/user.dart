import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class UserData extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String username;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String token;
  @HiveField(5)
  String password;

  UserData({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.phone = "",
    this.token = "",
  });
}
