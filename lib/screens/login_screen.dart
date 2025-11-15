import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:test_news/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Logo
                      Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(bottom: 40),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.directions_car,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => controller.setEmail(value),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: controller.validateEmail,
                      ),
                      const SizedBox(height: 20),
                      // Password Field
                      Obx(
                        () => TextFormField(
                          controller: _passwordController,
                          obscureText: controller.obscurePassword.value,
                          onChanged: (value) => controller.setPassword(value),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed:
                                  () => controller.togglePasswordVisibility(),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          validator: controller.validatePassword,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Login Button
                      Obx(
                        () => ElevatedButton(
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () {
                                    if (_formKey.currentState!.validate()) {
                                      controller.login(
                                        context,
                                        GoRouter.of(context),
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child:
                              controller.isLoading.value
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //======> Skip Login Button - Top Right
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  child: const Text(
                    'Skip Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
