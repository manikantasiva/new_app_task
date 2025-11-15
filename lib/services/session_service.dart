import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_news/models/user_model.dart';

class SessionService {
  static const String _userTokenKey = 'user_token';
  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  //======> Save user token (name + password)
  static Future<bool> saveUserToken(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = '$email:$password';
      final success = await prefs.setString(_userTokenKey, token);
      print(
        'SessionService.saveUserToken: Saving token for email=$email, success=$success',
      );
      return success;
    } catch (e) {
      print('SessionService.saveUserToken: Error=$e');
      return false;
    }
  }

  //======> Save user data
  static Future<bool> saveUserData(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(
        _userDataKey,
        jsonEncode(user.toJson()),
      );
      print(
        'SessionService.saveUserData: Saving user=${user.email}, success=$success',
      );
      return success;
    } catch (e) {
      print('SessionService.saveUserData: Error=$e');
      return false;
    }
  }

  //======> Get user token
  static Future<String?> getUserToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userTokenKey);
    } catch (e) {
      return null;
    }
  }

  //======> Get user data
  static Future<UserModel?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(_userDataKey);
      print(
        'SessionService.getUserData: Retrieved userDataString=${userDataString != null ? "exists" : "null"}',
      );
      if (userDataString != null) {
        final userData = jsonDecode(userDataString) as Map<String, dynamic>;
        final user = UserModel.fromJson(userData);
        print(
          'SessionService.getUserData: User email=${user.email}, name=${user.fullName}',
        );
        return user;
      }
      print('SessionService.getUserData: No user data found');
      return null;
    } catch (e) {
      print('SessionService.getUserData: Error=$e');
      return null;
    }
  }

  //======> Set login status
  static Future<bool> setLoginStatus(bool isLoggedIn) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final result = await prefs.setBool(_isLoggedInKey, isLoggedIn);
      print(
        'SessionService.setLoginStatus: Setting isLoggedIn=$isLoggedIn, result=$result',
      );
      // Verify it was saved
      final verify = prefs.getBool(_isLoggedInKey);
      print('SessionService.setLoginStatus: Verified value=$verify');
      return result;
    } catch (e) {
      print('SessionService.setLoginStatus: Error=$e');
      return false;
    }
  }

  //======> Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool(_isLoggedInKey);
      print('SessionService.isLoggedIn: Retrieved value=$value');
      final result = value ?? false;
      print('SessionService.isLoggedIn: Returning result=$result');
      return result;
    } catch (e) {
      print('SessionService.isLoggedIn: Error=$e');
      return false;
    }
  }

  //======> Clear session (logout)
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove(_userTokenKey);
      await prefs.remove(_userDataKey);
    } catch (e) {
      // Handle error
    }
  }

  //======>  Get email and password from token
  static Future<Map<String, String>?> getCredentialsFromToken() async {
    try {
      final token = await getUserToken();
      if (token != null && token.contains(':')) {
        final parts = token.split(':');
        if (parts.length == 2) {
          return {'email': parts[0], 'password': parts[1]};
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
