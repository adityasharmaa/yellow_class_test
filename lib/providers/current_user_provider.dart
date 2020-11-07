import 'package:flutter/material.dart';
import 'package:yellow_class_test/helpers/firebase_auth.dart';
import 'package:yellow_class_test/models/user.dart';

enum AuthenticateResponse {
  INVALID_EMAIL,
  SHORT_PASSWORD,
  PASSWORD_MISMATCH,
  SUCCESS,
  ERROR,
}

class CurrentUserProvider with ChangeNotifier {
  User _currentUser;

  User get currentUser {
    return _currentUser;
  }

  void prepareLogin() {
    var currentUser = Auth().getCurrentUser();
    _currentUser = User(
      id: currentUser.uid,
      name: currentUser.displayName,
      email: currentUser.email,
    );
  }

  bool _isEmailValid(String email) {
    if (email.isEmpty) return false;
    if (!email.contains("@")) return false;
    if (!email.contains(".")) return false;
    if (email.lastIndexOf(".") - email.indexOf("@") < 2) return false;
    return true;
  }

  Future<AuthenticateResponse> logIn(String email, String password) async {
    if (!_isEmailValid(email)) return AuthenticateResponse.INVALID_EMAIL;
    if (password.length < 6) return AuthenticateResponse.SHORT_PASSWORD;

    try {
      var user = await Auth().signIn(email, password);
      prepareLogin();
      return user != null
          ? AuthenticateResponse.SUCCESS
          : AuthenticateResponse.ERROR;
    } catch (e) {
      print(e.toString());
      return AuthenticateResponse.ERROR;
    }
  }

  Future<AuthenticateResponse> signUp(
      String email, String password, String confirmPassword) async {
    if (!_isEmailValid(email)) return AuthenticateResponse.INVALID_EMAIL;
    if (password.length < 6) return AuthenticateResponse.SHORT_PASSWORD;
    if (password != confirmPassword)
      return AuthenticateResponse.PASSWORD_MISMATCH;

    try {
      var user = await Auth().signUp(email, password);
      prepareLogin();
      return user != null
          ? AuthenticateResponse.SUCCESS
          : AuthenticateResponse.ERROR;
    } catch (e) {
      print(e.toString());
      return AuthenticateResponse.ERROR;
    }
  }

  Future<AuthenticateResponse> authenticate(
      {bool logInMode, String email, String password, String confirmPassword}) {
    return logInMode
        ? logIn(email, password)
        : signUp(email, password, confirmPassword);
  }
}
