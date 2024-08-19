import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:okradish/constants/storage_keys.dart';
import 'package:okradish/model/user.dart';
import 'package:okradish/services/connetivity.dart';

class AuthController extends GetxController {
  UserProfile _userProfile = UserProfile(
    id: "id",
    username: "",
    email: "",
    phone: "",
  );

  @override
  void onInit() {
    // save data when user connected to internet
    final connection = Get.find<Connection>();
    connection.onConnected(saveDateOnCloud);
    super.onInit();
  }

  // ---------------------------------------------------------------
  // Local DateBase Management

  Future<bool> checkToken() async {
    final box = await Hive.openBox('user');
    final token = await box.get(StorageKeys.token);
    return token != null;
  }

  // ---------------------------------------------------------------
  // Cloud DateBase Management
  Future saveDateOnCloud() async {
    log(level: 0, name: "AUTH", "syncing auth data ...");
  }

  // ---------------------------------------------------------------
  // Authentication
  Future signIn() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  Future signOut() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  Future singUp() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  Future resetPws() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  Future submitData() async {
    return Future.delayed(const Duration(seconds: 2));
  }

  // ---------------------------------------------------------------

  String password = "";

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

  String get token {
    return _userProfile.token;
  }

  set id(String newId) {
    if (newId.isNotEmpty) {
      _userProfile = UserProfile(
        id: newId,
        username: username,
        email: email,
        phone: phone,
        token: token,
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
        token: token,
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
      token: token,
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
        token: token,
      );
      update(['user']);
    }
  }

  set token(String newToken) {
    if (token.isNotEmpty) {
      _userProfile = UserProfile(
        id: id,
        username: username,
        email: email,
        phone: phone,
        token: newToken,
      );
      update(['user']);
    }
  }
}
