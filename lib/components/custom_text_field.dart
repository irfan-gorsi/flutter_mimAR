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
      return const Icon(Icons.person, color: Color(0xFF4A90E2));
    } else if (text.contains('email')) {
      return const Icon(Icons.email, color: Color(0xFF4A90E2));
    } else if (text.contains('password')) {
      return const Icon(Icons.lock, color: Color(0xFF4A90E2));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: _getLeadingIcon(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A90E2)),
        ),
      ),
    );
  }
}
