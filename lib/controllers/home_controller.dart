import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:test_news/models/user_model.dart';
import 'package:test_news/services/session_service.dart';

class HomeController extends GetxController {
  final currentUser = Rxn<UserModel>();
  final categories = <String>[].obs;

  void setUser(UserModel user) {
    currentUser.value = user;
  }

  void addCategory(String category, BuildContext context) {
    if (category.isNotEmpty && !categories.contains(category)) {
      categories.add(category);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category added successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void removeCategory(String category, BuildContext context) {
    categories.remove(category);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Category removed successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> logout(GoRouter router) async {
    // Clear session token
    await SessionService.clearSession();
    currentUser.value = null;
    router.go('/login');
  }
}
