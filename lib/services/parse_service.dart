import 'dart:developer';

import 'package:OKRADISH/constants/api_keys.dart';
import 'package:OKRADISH/constants/storage_keys.dart';
import 'package:OKRADISH/model/user.dart';
import 'package:OKRADISH/utils/response_validator.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseService {
  Future<void> saveData(String username, String phone) async {
    // save
    final ParseObject object = ParseObject(StorageKeys.user);
    var query = QueryBuilder(object)..whereEqualTo('username', username);
    var resp = await query.query();
    if (resp.success && resp.result != null) {
      var foundObj = resp.result as ParseObject;
      foundObj.set("phone", phone);
      resp = await foundObj.save();
      log(name: "AUTH", "found data at ${foundObj.objectId}");
    } else {
      object.set<String>("username", username);
      object.set<String>("phone", phone);
      resp = await object.save();
      log(name: "AUTH", "create data");
    }
    if (resp.success) {
      HTTPResponseValidator.validate(resp.statusCode);
    } else {
      HTTPResponseValidator.validate(resp.statusCode,
          message: resp.error!.message);
    }
  }

  Future<void> updateUser(
      String username, String email, String password, String token) async {
    final ParseUser user = await ParseUser.currentUser();
    user
      ..username = username
      ..password = password
      ..emailAddress = email;
    final resp = await user.update();
    if (resp.success) {
      HTTPResponseValidator.validate(resp.statusCode);
    } else {
      HTTPResponseValidator.validate(resp.statusCode,
          message: resp.error!.message);
    }
  }

  Future<void> requestPasswordReset(String email) async {
    final resp = await ParseUser(null, null, email).requestPasswordReset();
    if (resp.success) {
      HTTPResponseValidator.validate(resp.statusCode);
    } else {
      HTTPResponseValidator.validate(resp.statusCode,
          message: resp.error!.message);
    }
  }

  Future<void> requestEmailVerification(String email) async {
    final resp = await ParseUser(null, null, email).verificationEmailRequest();
    if (resp.success) {
      HTTPResponseValidator.validate(resp.statusCode);
    } else {
      HTTPResponseValidator.validate(resp.statusCode,
          message: resp.error!.message);
    }
  }

  Future<bool> checkEmailVerified(
      String? username, String? email, String? password) async {
    final user = ParseUser(username, password, email);
    if (user.emailVerified == null || !user.emailVerified!) {
      return false;
    }
    return true;
  }

  Future<void> initialize(String? token) async {
    await Parse().initialize(
      ApiKeys.applicationId,
      ApiKeys.parseServerUrl,
      clientKey: ApiKeys.clientKey,
      autoSendSessionId: true,
      sessionId: token,
    );
  }

  Future<UserData> signin(
      String? username, String? email, String password) async {
    final resp = await ParseUser(username, password, email).login();
    if (resp.success) {
      HTTPResponseValidator.validate(resp.statusCode);
    } else {
      HTTPResponseValidator.validate(resp.statusCode,
          message: resp.error!.message);
    }
    return UserData(
      id: resp.result['objectId'],
      username: resp.result['username'],
      email: resp.result['email'],
      password: password,
      token: resp.result['sessionToken'],
    );
  }

  Future<UserData> signup(
      String? username, String? email, String password) async {
    final resp = await ParseUser(username, password, email).signUp();
    if (resp.success && resp.result != null) {
      HTTPResponseValidator.validate(resp.statusCode);
    } else {
      HTTPResponseValidator.validate(resp.statusCode,
          message: resp.error!.message);
    }
    return UserData(
      id: resp.result['objectId'],
      username: resp.result['username'],
      email: resp.result['email'],
      password: password,
      token: resp.result['sessionToken'],
    );
  }

  Future<void> signout(
      String? username, String? email, String? password, String? token) async {
    final resp = await ParseUser(username, password, email, sessionToken: token)
        .logout();
    if (resp.success) {
      HTTPResponseValidator.validate(resp.statusCode);
    } else {
      HTTPResponseValidator.validate(resp.statusCode,
          message: resp.error!.message);
    }
  }
}
