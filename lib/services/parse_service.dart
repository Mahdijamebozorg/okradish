import 'package:OKRADISH/constants/api_keys.dart';
import 'package:OKRADISH/model/user.dart';
import 'package:OKRADISH/utils/response_validator.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseService {
  Future<void> saveData(String username, String phone) async {
    // Check if the user exists
    final QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject(ApiKeys.user))
          ..whereEqualTo('username', username);
    ParseResponse resp = await query.query();
    if (resp.success && resp.results != null && resp.results!.isNotEmpty) {
      // User exists, update their data
      final ParseObject user = resp.results!.first as ParseObject;
      // Update user data
      user.set('phone', phone);
      resp = await user.save();
    } else {
      // User does not exist, create a new user
      final ParseObject newUser = ParseObject(ApiKeys.user)
        ..set('username', username)
        ..set('phone', phone);
      resp = await newUser.save();
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
