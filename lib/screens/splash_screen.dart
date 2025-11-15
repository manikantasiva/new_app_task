import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:test_news/services/session_service.dart';
import 'package:test_news/controllers/home_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    try {
      print('SplashScreen: Checking login status...');
      final isLoggedIn = await SessionService.isLoggedIn();
      print('SplashScreen: isLoggedIn=$isLoggedIn');

      if (isLoggedIn) {
        print('SplashScreen: User is logged in, fetching user data...');
        final savedUser = await SessionService.getUserData();

        if (savedUser != null) {
          print('SplashScreen: User data found, email=${savedUser.email}');
          final homeController = Get.put(HomeController());
          homeController.setUser(savedUser);
          if (mounted) {
            print('SplashScreen: Navigating to home screen');
            context.go('/home');
            return;
          }
        } else {
          print('SplashScreen: User data is null');
        }
      } else {
        print('SplashScreen: User is not logged in');
      }
    } catch (e) {
      print('SplashScreen: Error=$e');
    }

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.directions_car,
                size: 80,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Test News',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
