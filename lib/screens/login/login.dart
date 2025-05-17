import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimar/components/headertext.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import 'login_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  Future<void> _checkIfLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');  // Consistent key

    if (token != null && context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    ref.read(loginControllerProvider.notifier).login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) async {
      next.when(
        data: (token) async {
          if (token != null && context.mounted) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('jwt_token', token);  
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        loading: () {},
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderText(
              title: 'Sign In',
              subtitle: 'Hi, welcome back',
            ),
            const SizedBox(height: 10),
            CustomTextField(controller: emailController, hintText: 'Email'),
            const SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            loginState.isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: 'Login',
                    onPressed: _login,
                  ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text(
                    "Signup",
                    style: TextStyle(color:  const Color(0xFF4A90E2),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
