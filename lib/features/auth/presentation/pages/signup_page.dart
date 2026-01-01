import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/auth/presentation/pages/login_page.dart';
import 'package:blood_link/core/widgets/my_multi_line_text_form_field.dart';
import 'package:blood_link/core/widgets/my_text_form_field.dart';
import 'package:blood_link/features/auth/presentation/state/auth_state.dart';
import 'package:blood_link/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _gender;
  String? _bloodGroup;
  final TextEditingController _healthConditionController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  bool _obscurePassword = true;

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

  final _formKey = GlobalKey<FormState>();

  // DOB picker state
  DateTime? _selectedDob;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _healthConditionController.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: now,
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;

        // DD / MM / YYYY
        _dobController.text =
            "${picked.day.toString().padLeft(2, '0')} / "
            "${picked.month.toString().padLeft(2, '0')} / "
            "${picked.year}";
      });
    }
  }

  bool _isUnder18(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;

    final hasHadBirthdayThisYear =
        (today.month > dob.month) ||
        (today.month == dob.month && today.day >= dob.day);

    if (!hasHadBirthdayThisYear) age--;

    return age < 18;
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDob == null) {
        SnackbarUtils.showError(context, "Please select your date of birth");
        return;
      }

      if (_isUnder18(_selectedDob!)) {
        SnackbarUtils.showError(context, "You must be at least 18 years old");
        return;
      }

      // ya ko data lai view model ma pass garnu paryo
      ref
          .read(authViewmodelProvider.notifier)
          .register(
            fullName: _fullNameController.text,
            phoneNumber: _phoneController.text.trim(),
            dob: _dobController.text,
            gender: _gender ?? "",
            bloodGroup: _bloodGroup ?? " ",
            email: _emailController.text.trim(),
            password: _pwController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // auth state
    ref.watch(authViewmodelProvider);

    // listen for auth state changes
    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? "Registration Failed",
        );
      } else if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(
          context,
          next.errorMessage ?? "Registration Successfull",
        );
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
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
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: screenWidth > 600 ? 500 : double.infinity,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),

                      // Back arrow and Logo
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
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
                          Image.asset(
                            'assets/images/small_logo.png',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Container for Signup form
                      Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withAlpha(
                                  (0.2 * 255).round(),
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Sign Up",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'BricolageGrotesque SemiBold',
                                  fontSize: 40,
                                ),
                              ),
                              const SizedBox(height: 10),

                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Already have an account?",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'BricolageGrotesque ExtraLight',
                                    fontSize: 15,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " Login",
                                      style: const TextStyle(
                                        color: Color(0xFFA72636),
                                        fontFamily:
                                            "BricolageGrotesque SemiBold",
                                      ),
                                      recognizer: _tapGestureRecognizer
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Full Name Input
                              MyTextFormField(
                                controller: _fullNameController,
                                labelText: "Full Name",
                                hintText: "Full Name",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Full name is required";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Phone Number Input
                              MyTextFormField(
                                controller: _phoneController,
                                labelText: "Phone Number",
                                hintText: "Enter your phone number",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Phone number is required";
                                  }
                                  if (value.length < 10) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // ✅ DOB Date Picker (NOT using MyTextFormField)
                              InkWell(
                                onTap: _pickDob,
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: "Date of Birth",
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    hintText: "DD / MM / YYYY",
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
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
                                    suffixIcon: const Icon(
                                      Icons.calendar_month,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Text(
                                    _dobController.text.isEmpty
                                        ? "DD / MM / YYYY"
                                        : _dobController.text,
                                    style: TextStyle(
                                      color: _dobController.text.isEmpty
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Gender Drop Down
                              DropdownButtonFormField(
                                initialValue: _gender,
                                decoration: InputDecoration(
                                  labelText: "Gender",
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  hintText: "Choose your gender",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
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
                                items: _genders
                                    .map(
                                      (String gender) =>
                                          DropdownMenuItem<String>(
                                            value: gender,
                                            child: Text(gender),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _gender = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),

                              // Blood Group Drop Down
                              DropdownButtonFormField(
                                initialValue: _bloodGroup,
                                decoration: InputDecoration(
                                  labelText: "Blood Group",
                                  labelStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                  hintText: "Choose your Blood Group",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
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
                                items: _bloodGroups
                                    .map(
                                      (String blood) =>
                                          DropdownMenuItem<String>(
                                            value: blood,
                                            child: Text(blood),
                                          ),
                                    )
                                    .toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _bloodGroup = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),

                              // Prevailing Health Condition
                              MyMultiLineTextFormField(
                                controller: _healthConditionController,
                                labelText: "Prevailing Health Conditions",
                                hintText: "Type here...",
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
                              const SizedBox(height: 20),

                              // Confirm Password (still using same controller as your code)
                              MyTextFormField(
                                controller: _confirmPwController,
                                labelText: "Confirm your password",
                                hintText: "Re-enter your password",
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
                                  if (value != _pwController.text) {
                                    return 'Password do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Sign Up Button
                              ElevatedButton(
                                onPressed: _handleSignup,
                                child: const Text("Sign Up"),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
