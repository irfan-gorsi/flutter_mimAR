import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimar/components/headertext.dart';
import '../../components/custom_button.dart';
import '../../components/custom_text_field.dart';
import 'signup_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  late final TextEditingController fullnameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    fullnameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    // Simple email regex
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupControllerProvider);
    final signupNotifier = ref.read(signupControllerProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderText(
              title: 'Create Account',
              subtitle: 'Fill your information below',
            ),
            const SizedBox(height: 10),

            CustomTextField(
              controller: fullnameController,
              hintText: 'Full Name',
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 16),

            signupState.isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: 'Signup',
                    onPressed: () async {
                      final fullname = fullnameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (fullname.isEmpty || email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill in all fields.")),
                        );
                        return;
                      }

                      if (!isValidEmail(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter a valid email address.")),
                        );
                        return;
                      }

                      await signupNotifier.signup(fullname, email, password);

                      final state = ref.read(signupControllerProvider);
                      if (state.hasError) {
                        final errorMessage = state.error.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage)),
                        );
                      } else if (state.hasValue &&
                          state.value != null &&
                          context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.value!)),
                        );

                        // Navigate to login after short delay
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.pushReplacementNamed(context, '/login');
                        });
                      }
                    },
                  ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Color(0xFF4A90E2)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
