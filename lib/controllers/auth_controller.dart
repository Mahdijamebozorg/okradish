import 'package:get/get.dart';
import 'package:okradish/model/user.dart';

class AuthController extends GetxController {
  UserProfile _userProfile = UserProfile(
    id: "id",
    username: '',
    email: '',
    phone: "",
  );
  String password = "";
  String token = "";

  String get id {
    return _userProfile.id;
  }

  String get username {
    return _userProfile.username;
  }

  String get email {
    return _userProfile.email;
  }

  String get phone {
    return _userProfile.phone;
  }

  set id(String newId) {
    if (newId.isNotEmpty) {
      _userProfile = UserProfile(
        id: newId,
        username: username,
        email: email,
        phone: phone,
      );
      update(['user']);
    }
  }

  set username(String newUsername) {
    if (newUsername.isNotEmpty) {
      _userProfile = UserProfile(
        id: id,
        username: newUsername,
        email: email,
        phone: phone,
      );
      update(['user']);
    }
  }

  set phone(String newPhone) {
    _userProfile = UserProfile(
      id: id,
      username: username,
      email: email,
      phone: newPhone,
    );
    update(['user']);
  }

  set email(String newEmail) {
    if (newEmail.isNotEmpty) {
      _userProfile = UserProfile(
        id: id,
        username: username,
        email: newEmail,
        phone: phone,
      );
      update(['user']);
    }
  }

  Future signIn() async {
    email = "someone@email.com";
    phone = "0989188181818";
    return Future.delayed(const Duration(seconds: 2));
  }

  Future signOut() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  Future singUp() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  Future resetPws() async {
    username = "someone";
    email = "someone@email.com";
    phone = "0989188181818";
    return Future.delayed(const Duration(seconds: 2));
  }

  Future submitData() async {
    return Future.delayed(const Duration(seconds: 2));
  }
}
