import 'package:blood_link/screens/home_screen.dart';
import 'package:blood_link/screens/sign_up_screen.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:blood_link/widgets/my_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEC99A4), // top color
              Color(0xFFA72636), // bottom color
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/small_logo.png',
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 10),

              // Container for Login form
              Container(
                padding: const EdgeInsets.all(20), // inner spacing
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha((0.2 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title
                    Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Bricolage Grotesque',
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subtitle
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: "Don't have an account?",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Bricolage Grotesque',
                          fontSize: 15,
                          fontWeight: FontWeight.w200,
                        ),
                        children: [
                          TextSpan(
                            text: " Sign Up",
                            style: const TextStyle(
                              color: Color(0xFFA72636),
                              fontWeight: FontWeight.w600,
                            ),
                            recognizer: _tapGestureRecognizer
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Email Input
                    MyTextFormField(
                      controller: _emailController,
                      labelText: "Enter your email",
                      hintText: "abc@gmail.com",
                      errorMessage: "Please enter valid email address",
                    ),
                    const SizedBox(height: 20),
                    // Password Input
                    MyTextFormField(
                      controller: _pwController,
                      labelText: "Enter your password",
                      hintText: "Password",
                      errorMessage: "Wrong email or password. Please try again",
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              activeColor: const Color(0xFFA72636),
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            Text(
                              "Remember Me",
                              style: TextStyle(
                                fontFamily: 'Bricolage Grotesque',
                                fontSize: 14,
                                fontWeight: FontWeight.w200,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        // Forgot Password clickable text
                        GestureDetector(
                          onTap: () {
                            // Navigate to forgot password screen or show dialog
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              fontFamily: 'Bricolage Grotesque',
                              fontSize: 14,
                              color: Color(0xFFA72636),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Invisible Box
                    SizedBox(height: 20),

                    // Login Button
                    MyButton1(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      text: "Login",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
