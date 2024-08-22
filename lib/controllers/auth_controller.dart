import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:okradish/constants/api_keys.dart';
import 'package:okradish/constants/storage_keys.dart';
import 'package:okradish/constants/strings.dart';
import 'package:okradish/model/user.dart';
import 'package:okradish/widgets/snackbar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthController extends GetxController {
  ParseUser? _parseUser;
  UserData? _userData = UserData(
    phone: "",
    email: "",
    id: "",
    password: "",
    username: "",
    token: "",
  );

  final RxBool isWorking = false.obs;
  final RxBool isAuth = false.obs;
  final RxBool isOnline = false.obs;

  @override
  void onInit() {
    // save data when user connected to internet
    Connectivity().onConnectivityChanged.listen(
      (event) async {
        if (isAuth.value) {
          //if internet is on
          if (event == ConnectivityResult.wifi ||
              event == ConnectivityResult.mobile) {
            if (isAuth.value) {
              // login if not
              isWorking.value = true;
              await Parse().initialize(
                ApiKeys.applicationId,
                ApiKeys.parseServerUrl,
                clientKey: ApiKeys.clientKey,
                autoSendSessionId: true,
                sessionId: token,
              );
              isWorking.value = false;
              // read user
              _parseUser = await ParseUser.currentUser();
              // submit changes
              isOnline.value = true;
              if (!isWorking.value) {
                log(name: "AUTH", "syncing...");
                isWorking.value = true;
                await _parseUser!.save();
                isWorking.value = false;
              }
            }
          }
          //if internet is off
          else {
            isOnline.value = false;
          }
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
    await box.put(StorageKeys.user, _userData!);
  }

  Future<UserData?> loadFromLocal() async {
    log(name: "AUTH", "load data from device");
    final box = await Hive.openBox<UserData>(StorageKeys.user);
    return box.get(StorageKeys.user);
  }

  Future<void> removeFromLocal() async {
    log(name: "AUTH", "remove data from device");
    final box = await Hive.openBox<UserData>(StorageKeys.user);
    await box.delete(StorageKeys.user);
  }

  // ---------------------------------------------------------------
  // Cloud DateBase Management

  Future<void> saveOnCloud() async {
    log(name: "AUTH", "saving data on cloud");
    try {
      // check if is online
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.mobile ||
          connectivity == ConnectivityResult.wifi) {
        // save
        final ParseObject object = ParseObject(StorageKeys.user);
        var query = QueryBuilder(object)..whereEqualTo('username', username);
        var response = await query.query();

        if (response.success) {
          await (object
                ..set("username", username)
                ..set("phone", phone))
              .save();
        } else {
          await (object
                ..set("username", username)
                ..set("phone", phone))
              .create();
        }
        // final response = await (object..set("phone", phone)..set("username":username)).create();
      }
      // if offline
      else {
        getSnackBar(ErrorTexts.internet);
      }
    } catch (e) {
      getSnackBar(e.toString());
    }
  }

  // ---------------------------------------------------------------
  // Authentication

  Future<String> requestResetPwd() async {
    try {
      isWorking.value = true;
      _parseUser = ParseUser(null, null, email);
      final resp = await _parseUser!.requestPasswordReset();
      if (!resp.success) {
        isWorking.value = false;
        return resp.error!.message;
      }
      isWorking.value = false;
      return "";
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  Future<String> requestEmailVerification() async {
    try {
      isWorking.value = true;
      final resp = await _parseUser!.verificationEmailRequest();
      if (!resp.success) {
        isWorking.value = false;
        return resp.error!.message;
      }
      isWorking.value = false;
      return "";
    } catch (e) {
      isWorking.value = false;
      return e.toString();
    }
  }

  Future<String> signIn() async {
    isWorking.value = true;
    final connectivity = await Connectivity().checkConnectivity();
    // if online
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      try {
        log(name: "AUTH", "signing in ...");
        // sign in
        _parseUser = ParseUser(username, password, null);
        // check verification
        // if (_parseUser!.emailVerified == null || !_parseUser!.emailVerified!) {
        //   isWorking.value = false;
        //   return ErrorTexts.emailNotVerified;
        // }
        final ParseResponse response = await _parseUser!.login();
        if (!response.success) {
          isWorking.value = false;
          return response.error!.message;
        }

        log(name: "AUTH", response.results.toString());
        _userData = UserData(
          id: response.result['objectId'],
          username: response.result['username'],
          email: response.result['email'],
          password: _userData!.password,
          token: response.result['sessionToken'],
        );
        _parseUser = ParseUser(username, password, email);

        // make/upload userdate on cloud
        await saveOnCloud();

        // save token
        await saveOnLocal();
        isAuth.value = true;
        isWorking.value = false;
        update(['user']);
        return "";
      } catch (e) {
        isWorking.value = false;
        return e.toString();
      }
    } else {
      isWorking.value = false;
      return ErrorTexts.noInternet;
    }
  }

  Future<String> singUp() async {
    isWorking.value = true;
    final connectivity = await Connectivity().checkConnectivity();
    // if online
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      log(name: "AUTH", "signing up ...");
      try {
        _parseUser = ParseUser(username, password, email);
        final ParseResponse response =
            await _parseUser!.signUp(allowWithoutEmail: false);
        if (!response.success) {
          isWorking.value = false;
          return response.error!.message;
        }
        isWorking.value = false;
        return "";
      } catch (e) {
        isWorking.value = false;
        return e.toString();
      }
    } else {
      isWorking.value = false;
      return ErrorTexts.noInternet;
    }
  }

  Future<String> tokenLogin() async {
    isWorking.value = true;
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi) {
      log(name: "AUTH", "token login ...");
      try {
        // load token
        _userData = await loadFromLocal();
        if (_userData != null && _userData!.token.isNotEmpty) {
          // login
          await Parse().initialize(
            ApiKeys.applicationId,
            ApiKeys.parseServerUrl,
            clientKey: ApiKeys.clientKey,
            autoSendSessionId: true,
            sessionId: token,
          );
          // read user
          _parseUser = await ParseUser.currentUser();

          // make/upload userdate on cloud
          await saveOnCloud();

          isAuth.value = true;
          isWorking.value = false;
          update(['user']);
          return "";
        }
      } catch (e) {
        isWorking.value = false;
        return e.toString();
      }
    } else {
      // offline mode
      _userData = await loadFromLocal();
      if (_userData != null && _userData!.token.isNotEmpty) {
        // login
        await Parse().initialize(
          ApiKeys.applicationId,
          ApiKeys.parseServerUrl,
          clientKey: ApiKeys.clientKey,
          autoSendSessionId: true,
          sessionId: token,
        );
        // read user
        _parseUser = await ParseUser.currentUser();
        isAuth.value = true;
        isWorking.value = false;
        return '';
      }
      // return ErrorTexts.noInternet;
    }
    _userData = UserData(
      id: "",
      username: "",
      email: "",
      password: "",
    );
    isWorking.value = false;
    return "token failed";
  }

  Future<bool> signOut() async {
    isWorking.value = true;
    try {
      final response = await _parseUser!.logout();
      if (!response.success) {
        isWorking.value = false;
        return false;
      }
      await removeFromLocal();
      isAuth.value = false;
      isWorking.value = false;
      update(['user']);
      return true;
    } catch (e) {
      isWorking.value = false;
      return false;
    }
  }

  // ---------------------------------------------------------------

  String get id {
    return _userData!.id;
  }

  String get username {
    return _userData!.username;
  }

  String get email {
    return _userData!.email;
  }

  String get phone {
    return _userData!.phone;
  }

  String get token {
    return _userData!.token;
  }

  String get password {
    return _userData!.password;
  }

  Future<String> submitData() async {
    // cloud
    try {
      _parseUser = (((_parseUser!..username = username)..emailAddress = email)
        ..password = password);
      await _parseUser!.save();
    } catch (e) {
      return ErrorTexts.internet;
    }
    // local
    await saveOnCloud();
    await saveOnLocal();
    update(['user']);
    return "";
  }

  Future<String> resetPwd() async {
    _parseUser!.password = password;
    // cloud
    try {
      isWorking.value = true;
      _parseUser = _parseUser!..password = password;
      await _parseUser!.save();
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
