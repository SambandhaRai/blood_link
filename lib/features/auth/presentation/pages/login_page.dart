import 'package:blood_link/app/routes/app_routes.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen_layout.dart';
import 'package:blood_link/features/onboarding/presentation/pages/on_boarding_page.dart';
import 'package:blood_link/features/auth/presentation/pages/signup_page.dart';
import 'package:blood_link/core/widgets/my_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewmodelProvider.notifier)
          .login(
            email: _emailController.text.trim(),
            password: _pwController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        AppRoutes.pushReplacement(context, BottomScreenLayout());
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

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
                                builder: (context) => const OnBoardingPage(),
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
                              fontFamily: 'BricolageGrotesque SemiBold',
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
                                fontFamily: 'BricolageGrotesque ExtraLight',
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: " Sign Up",
                                  style: const TextStyle(
                                    color: Color(0xFFA72636),
                                    fontFamily: "BricolageGrotesque SemiBold",
                                  ),
                                  recognizer: _tapGestureRecognizer
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpPage(),
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Password Input
                          MyTextFormField(
                            controller: _pwController,
                            labelText: "Enter your password",
                            hintText: "Password",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
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
                                      fontFamily:
                                          'BricolageGrotesque ExtraLight',
                                      fontSize: 14,
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
                                    fontFamily: 'BricolageGrotesque SemiBold',
                                    fontSize: 14,
                                    color: Color(0xFFA72636),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Login Button
                          ElevatedButton(
                            onPressed: _handleLogin,
                            child: Text("Login"),
                          ),
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
