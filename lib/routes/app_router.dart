import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_news/screens/splash_screen.dart';
import 'package:test_news/screens/login_screen.dart';
import 'package:test_news/screens/home_screen.dart';
import 'package:test_news/screens/add_news_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/add-news',
        name: 'add-news',
        builder: (context, state) => const AddNewsScreen(),
      ),
     
    ],
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('Error: ${state.error}'))),
  );
}
