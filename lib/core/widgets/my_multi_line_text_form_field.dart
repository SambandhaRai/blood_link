import 'package:flutter/material.dart';

class MyMultiLineTextFormField extends StatelessWidget {
  const MyMultiLineTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.errorMessage,
    this.maxLines = 3, // default height
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? errorMessage;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFA72636), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 18,
        ),
      ),
    );
  }
}
