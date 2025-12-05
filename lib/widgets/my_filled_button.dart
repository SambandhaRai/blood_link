import 'package:flutter/material.dart';

class MyFilledButton extends StatelessWidget {
  const MyFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFFA72636),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Bricolage Grotesque',
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}
