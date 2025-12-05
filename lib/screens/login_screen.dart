import 'package:blood_link/screens/home_screen.dart';
import 'package:blood_link/screens/on_boarding_screen.dart';
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

  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                // Prevent stretching on tablets/larger displays
                maxWidth: screenWidth > 600 ? 500 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Back arrow and Logo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Back Arrow at top-left
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OnBoardingScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      // Logo centered
                      Image.asset(
                        'assets/images/small_logo.png',
                        width: 50,
                        height: 50,
                      ),
                    ],
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
                    child: Form(
                      key: _formKey,
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
                                          builder: (context) =>
                                              const SignUpScreen(),
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
                            errorMessage:
                                "Wrong email or password. Please try again",
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Remember me + Forgot Password
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
                          const SizedBox(height: 20),

                          // Login Button
                          MyButton1(onPressed: login, text: "Login"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
