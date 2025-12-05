import 'dart:async';
import 'package:blood_link/screens/on_boarding_screen_1.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingScreen1()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Make logo 25-35% of screen height for better visibility
    final logoHeight = screenHeight * 0.3;

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
