import 'package:get/get.dart';
import 'package:okradish/model/user.dart';

class ProfileController extends GetxController {
  var userProfile = UserProfile(
    id: "id",
    username: 'John Doe',
    email: 'johndoe@example.com',
    phone: "09189181818",
    token: "token"
  ).obs;

  void updateUsername(String newUsername) {
    userProfile.update((user) {
      user?.username = newUsername;
    });
    update(['user']);
  }

  void updatePhone(String newPhone) {
    userProfile.update((user) {
      user?.phone = newPhone;
    });
    update(['user']);
  }
}
