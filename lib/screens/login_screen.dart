import 'package:blood_link/widgets/my_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Input
            MyTextFormField(
              controller: _emailController,
              labelText: "Enter your email",
              hintText: "abc@gmail.com",
              errorMessage: "Please enter valid email address",
            ),
            // Invisible Box
            SizedBox(height: 20),
            // Email Input
            MyTextFormField(
              controller: _pwControler,
              labelText: "Enter your password",
              hintText: "Password",
              errorMessage: "Please enter valid email address",
            ),
          ],
        ),
      ),
    );
  }
}
