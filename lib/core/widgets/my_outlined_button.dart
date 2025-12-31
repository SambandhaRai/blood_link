import 'package:flutter/material.dart';

class MyOutlinedButton extends StatelessWidget {
  const MyOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderColor = Colors.black,
    this.textColor = Colors.black,
  });

  final VoidCallback onPressed;
  final String text;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent, // no background
        surfaceTintColor: Colors.transparent, // remove Material overlay
        shadowColor: Colors.transparent, // remove shadow
        elevation: 0, // flatten button
        side: BorderSide(color: borderColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Bricolage Grotesque',
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: textColor,
        ),
      ),
    );
  }
}
