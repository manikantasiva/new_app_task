import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:test_news/services/auth_service.dart';
import 'package:test_news/services/session_service.dart';
import 'package:test_news/controllers/home_controller.dart';

class LoginController extends GetxController {
  final emailController = ''.obs;
  final passwordController = ''.obs;
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void setEmail(String value) {
    emailController.value = value;
  }

  void setPassword(String value) {
    passwordController.value = value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  Future<void> login(BuildContext context, GoRouter router) async {
    //======> Validate email and password are not empty
    if (emailController.value.isEmpty || passwordController.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    //======> Validate email format
    final emailError = validateEmail(emailController.value);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    //======> Validate password format
    final passwordError = validatePassword(passwordController.value);
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordError),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    isLoading.value = true;

    try {
      final user = await AuthService.validateUser(
        emailController.value.trim(),
        passwordController.value.trim(),
      );

      if (user != null) {
        print(
          'LoginController.login: User validated successfully, email=${user.email}',
        );

        // Save user token (email + password) for session
        final tokenSaved = await SessionService.saveUserToken(
          emailController.value.trim(),
          passwordController.value.trim(),
        );
        print('LoginController.login: Token saved=$tokenSaved');

        // Save user data
        final userDataSaved = await SessionService.saveUserData(user);
        print('LoginController.login: User data saved=$userDataSaved');

        // Set login status to true
        final loginStatusSet = await SessionService.setLoginStatus(true);
        print('LoginController.login: Login status set=$loginStatusSet');

        // Verify login status was set
        final verifyLoginStatus = await SessionService.isLoggedIn();
        print(
          'LoginController.login: Verified login status=$verifyLoginStatus',
        );

        final homeController = Get.put(HomeController());
        homeController.setUser(user);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 800));

        router.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not a valid user'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login failed. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.value = '';
    passwordController.value = '';
    super.onClose();
  }
}
