import 'dart:developer';
import 'package:OKRADISH/services/data_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:OKRADISH/constants/storage_keys.dart';
import 'package:OKRADISH/constants/strings.dart';
import 'package:OKRADISH/model/user.dart';
import 'package:OKRADISH/services/parse_service.dart';

class AuthController extends GetxController {
  UserData _userData = UserData(
    phone: "",
    email: "",
    id: "",
    password: "",
    username: "",
    token: "",
  );
  final parse = ParseService();
  final RxBool isWorking = false.obs;
  final RxBool isAuth = false.obs;
  final RxBool isOnline = false.obs;

  @override
  void onInit() {
    // save data when user connected to internet
    Connectivity().onConnectivityChanged.listen(
      (event) async {
        if (isWorking.value) return;
        if (!isAuth.value) return;
        if (isOnline.value) return;
        //if internet is on
        if (event == ConnectivityResult.wifi ||
            event == ConnectivityResult.mobile) {
          isWorking.value = true;
          try {
            log(name: "AUTH", "syncing...");
            await parse.initialize(token);
            await parse.updateUser(username, email, password, token);
            isOnline.value = true;
          } catch (e) {}
          isWorking.value = false;
        }
        //if internet is off
        else {
          isOnline.value = false;
        }
      },
    );
    super.onInit();
  }

  // ---------------------------------------------------------------
  // Local DateBase Management

  Future<void> saveOnLocal() async {
    log(name: "AUTH", "save data on device");
    final box = await Hive.openBox<UserData>(StorageKeys.user);
    await box.put(StorageKeys.user, _userData);
  }

  Future<UserData?> loadFromLocal() async {
    final box = await Hive.openBox<UserData>(StorageKeys.user);
    final data = box.get(StorageKeys.user);
    if (data == null) {
      log(name: "AUTH", "no data found on device");
    } else {
      log(name: "AUTH", "data loaded from device");
    }
    return data;
  }

  Future<void> removeFromLocal() async {
    log(name: "AUTH", "remove data from device");
    final box = await Hive.openBox<UserData>(StorageKeys.user);
    await box.deleteFromDisk();
    await Get.find<DataSevice>().deleteData();
  }

  // ---------------------------------------------------------------
  // Cloud DateBase Management

  Future<String> saveOnCloud() async {
    log(name: "AUTH", "saving data on cloud");
    log(name: "AUTH", "username: $username");
    log(name: "AUTH", "phone: $phone");
    try {
      isWorking.value = true;
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        await parse.saveData(username, phone);
        isWorking.value = false;
        return "";
      }
      // if offline
      else {
        isWorking.value = false;
        return ErrorTexts.noInternet;
      }
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  // ---------------------------------------------------------------
  // Authentication

  Future<String> requestResetPwd() async {
    try {
      isWorking.value = true;
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        await parse.requestPasswordReset(email);
        isWorking.value = false;
        return "";
      }
      // if offline
      else {
        isWorking.value = false;
        return ErrorTexts.noInternet;
      }
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  Future<String> requestEmailVerification() async {
    try {
      isWorking.value = true;
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        await parse.requestEmailVerification(email);
        isWorking.value = false;
        return "";
      }
      // if offline
      else {
        isWorking.value = false;
        return ErrorTexts.noInternet;
      }
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  Future<String> signIn() async {
    try {
      isWorking.value = true;
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        //
        _userData = await parse.signin(username, email, password);
        // save user data on device
        await saveOnLocal();

        isWorking.value = false;
        isAuth.value = true;
        return "";
      }
      // if offline
      else {
        isWorking.value = false;
        return ErrorTexts.noInternet;
      }
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  Future<String> singUp() async {
    try {
      isWorking.value = true;
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        //
        _userData = await parse.signup(username, email, password);
        isWorking.value = false;
        isAuth.value = true;
        return "";
      }
      // if offline
      else {
        isWorking.value = false;
        return ErrorTexts.noInternet;
      }
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  Future<String> tokenLogin() async {
    try {
      isWorking.value = true;
      var loadedData = await loadFromLocal();
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        // load token
        if (loadedData != null && loadedData.token.isNotEmpty) {
          _userData = loadedData;
          // login
          await parse.initialize(token);

          isAuth.value = true;
          isWorking.value = false;
          update(['user']);
          return "";
        }
      }
      // if offline
      else {
        // offline mode
        if (loadedData != null && loadedData.token.isNotEmpty) {
          _userData = loadedData;
          // login
          await parse.initialize(token);
          // read user
          isAuth.value = true;
          isWorking.value = false;
          return '';
        }
      }
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
    isWorking.value = false;
    return ErrorTexts.authFailed;
  }

  Future<String> signOut() async {
    isWorking.value = true;
    try {
      isWorking.value = true;
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        //
        await parse.signout(username, email, password, token);

        await removeFromLocal();

        isWorking.value = false;
        isAuth.value = false;
        return "";
      }
      // if offline
      else {
        isWorking.value = false;
        return ErrorTexts.noInternet;
      }
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  // ---------------------------------------------------------------

  String get id {
    return _userData.id;
  }

  String get username {
    return _userData.username;
  }

  String get email {
    return _userData.email;
  }

  String get phone {
    return _userData.phone;
  }

  String get token {
    return _userData.token;
  }

  String get password {
    return _userData.password;
  }

  Future<String> submitData() async {
    log(name: "AUTH", "Submiting user data");
    isWorking.value = true;
    // cloud
    try {
      await parse.updateUser(username, email, password, token);
      log(name: "AUTH", "user updated");
      if (phone.isNotEmpty) await saveOnCloud();
      log(name: "AUTH", "userdata on cloud updated");
    } catch (e) {
      isWorking.value = false;
      return ErrorTexts.internet;
    }

    await saveOnLocal();
    log(name: "AUTH", "userdata on device updated");
    update(['user']);
    isWorking.value = false;
    return "";
  }

  Future<String> resetPwd() async {
    // cloud
    try {
      isWorking.value = true;
      await parse.requestPasswordReset(email);
    } catch (e) {
      isWorking.value = false;
      return ErrorTexts.internet;
    }
    // local
    await saveOnLocal();
    isWorking.value = false;
    update(['user']);
    return "";
  }

  set username(String newUsername) {
    if (newUsername.isNotEmpty) {
      _userData = UserData(
        id: id,
        username: newUsername,
        email: email,
        password: password,
        token: token,
        phone: phone,
      );
      update(['user']);
    }
  }

  set phone(String newPhone) {
    _userData = UserData(
      id: id,
      username: username,
      email: email,
      password: password,
      token: token,
      phone: newPhone,
    );
    update(['user']);
  }

  set password(String newPassword) {
    if (newPassword.isNotEmpty) {
      _userData = UserData(
        id: id,
        username: username,
        email: email,
        password: newPassword,
        token: token,
        phone: phone,
      );
      update(['user']);
    }
  }

  set email(String newEmail) {
    if (newEmail.isNotEmpty) {
      _userData = UserData(
        id: id,
        username: username,
        email: newEmail,
        password: password,
        token: token,
        phone: phone,
      );
      update(['user']);
    }
  }
}
