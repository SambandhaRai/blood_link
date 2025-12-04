import 'package:blood_link/screens/login_screen.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:blood_link/widgets/my_multi_line_text_form_field.dart';
import 'package:blood_link/widgets/my_text_form_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _gender;
  String? _bloodGroup;
  final TextEditingController _healthConditionController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  final List<String> _genders = ['Male', 'Female', 'Others'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
            width: double.infinity,
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

                  // Container for Signup form
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
                          "Sign Up",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Bricolage Grotesque',
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        // Invisible Box
                        const SizedBox(height: 10),
                        // Subtitle
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Already have an account?",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Bricolage Grotesque',
                              fontSize: 15,
                              fontWeight: FontWeight.w200,
                            ),
                            children: [
                              TextSpan(
                                text: " Login",
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
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        // Invisible Box
                        const SizedBox(height: 20),
                        // Full Name Input
                        MyTextFormField(
                          controller: _fullNameController,
                          labelText: "Full Name",
                          hintText: "Full Name",
                          errorMessage: "Please enter your full name",
                        ),
                        // Invisible Box
                        const SizedBox(height: 20),
                        // Dob Input
                        MyTextFormField(
                          controller: _dobController,
                          labelText: "Date of Birth",
                          hintText: "DD / MM / YYYY",
                          errorMessage: "Please enter your date of birth",
                        ),
                        // Invisible Box
                        const SizedBox(height: 20),

                        // Gender Drop Down
                        DropdownButtonFormField(
                          initialValue: _gender,
                          decoration: InputDecoration(
                            labelText: "Gender",
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintText: "Choose your gender",
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFA72636),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 18,
                            ),
                          ),
                          items: _genders.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _gender = newValue;
                            });
                          },
                        ),
                        // Invisible Box
                        SizedBox(height: 20),

                        // Blood Group Drop Down
                        DropdownButtonFormField(
                          initialValue: _bloodGroup,
                          decoration: InputDecoration(
                            labelText: "Blood Group",
                            labelStyle: const TextStyle(color: Colors.grey),
                            hintText: "Choose your Blood Group",
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFA72636),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 18,
                            ),
                          ),
                          items: _bloodGroups.map((String blood) {
                            return DropdownMenuItem<String>(
                              value: blood,
                              child: Text(blood),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _bloodGroup = newValue;
                            });
                          },
                        ),
                        // Invisible Box
                        SizedBox(height: 20),

                        // Prevailing Health Condition
                        MyMultiLineTextFormField(
                          controller: _healthConditionController,
                          labelText: "Prevailing Health Conditions",
                          hintText: "Type here...",
                          errorMessage:
                              "Please enter any prevailing health conditions",
                        ),
                        // Invisible Box
                        SizedBox(height: 20),

                        // Email Input
                        MyTextFormField(
                          controller: _emailController,
                          labelText: "Enter your email",
                          hintText: "abc@gmail.com",
                          errorMessage: "Please enter valid email address",
                        ),
                        // Invisible Box
                        const SizedBox(height: 20),
                        // Password Input
                        MyTextFormField(
                          controller: _pwController,
                          labelText: "Enter your password",
                          hintText: "Password",
                          errorMessage:
                              "Wrong email or password. Please try again",
                        ),
                        // Invisible Box
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [],
                        ),
                        // Invisible Box
                        SizedBox(height: 20),

                        // Login Button
                        MyButton1(
                          onPressed: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ))
                          },
                          text: "Sign Up",
                        ),
                        // Invisible Box
                        SizedBox(height: 20),
                      ],
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
