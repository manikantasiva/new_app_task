import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:test_news/models/user_model.dart';

class AuthService {
  static Future<List<UserModel>> loadUsers() async {
    try {
      final String response = await rootBundle.loadString(
        'lib/data/users.json',
      );
      final data = json.decode(response) as Map<String, dynamic>;

      if (data['users'] == null) {
        return [];
      }

      final List<dynamic> usersList = data['users'] as List<dynamic>;
      return usersList
          .map((user) => UserModel.fromJson(user as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static Future<UserModel?> validateUser(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return null;
      }

      final users = await loadUsers();

      if (users.isEmpty) {
        return null;
      }

      try {
        final user = users.firstWhere(
          (user) =>
              user.email.toLowerCase().trim() == email.toLowerCase().trim() &&
              user.password == password,
        );
        return user;
      } catch (e) {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
