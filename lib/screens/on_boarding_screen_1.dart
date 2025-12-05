import 'package:blood_link/screens/on_boarding_screen_2.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:blood_link/widgets/on_boarding_dots.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen1 extends StatelessWidget {
  const OnBoardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Main content: image + text
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image
                    Flexible(
                      flex: 5,
                      child: Image.asset(
                        'assets/images/on_boarding_1.png',
                        height: screenHeight * 0.4,
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Invisible Box
                    SizedBox(height: screenHeight * 0.03),
                    // Title
                    Flexible(
                      flex: 2,
                      child: Text(
                        "Save Lives with a Single Tap",
                        style: TextStyle(
                          fontFamily: 'Bricolage Grotesque',
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // Invisible Box
                    SizedBox(height: screenHeight * 0.015),
                    // Subtitle
                    Flexible(
                      flex: 2,
                      child: Text(
                        "A secure and fast platform connecting blood donors with people in need.",
                        style: TextStyle(
                          fontFamily: 'Bricolage Grotesque',
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom section: dots + button
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Dots Indicator
                    OnBoardingDots(currentIndex: 0),
                    // Invisible Box
                    SizedBox(height: screenHeight * 0.02),
                    // Next Button
                    MyButton1(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnBoardingScreen2(),
                          ),
                        );
                      },
                      text: "Next",
                    ),
                    // Invisible Box
                    SizedBox(height: screenHeight * 0.03),
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
