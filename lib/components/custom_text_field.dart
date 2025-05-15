import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    super.key,
  });

  Icon? _getLeadingIcon() {
    final text = hintText.toLowerCase();
    if (text.contains('name')) {
      return const Icon(Icons.person);
    } else if (text.contains('email')) {
      return const Icon(Icons.email);
    } else if (text.contains('password')) {
      return const Icon(Icons.lock);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.black,  // <-- Your focus border color here
            width: 2,
          ),
        ),
        hintText: hintText,
        prefixIcon: _getLeadingIcon(),
      ),
    );
  }
}
