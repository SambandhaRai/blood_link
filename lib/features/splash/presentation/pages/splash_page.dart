import 'dart:async';
import 'package:blood_link/features/onboarding/presentation/pages/on_boarding_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final logoHeight = screenHeight * 0.5;

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/blood_link_logo_red.png',
          height: logoHeight,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
