import 'package:blood_link/screens/on_boarding_screen_3.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:blood_link/widgets/on_boarding_dots.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen2 extends StatelessWidget {
  const OnBoardingScreen2({super.key});

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
                        'assets/images/on_boarding_2.png',
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
                        "Connect with the Right Donor",
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
                        "We only show you blood requests that match your blood group for accurate and safe donations.",
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
                    OnBoardingDots(currentIndex: 1),
                    // Invisible Box
                    SizedBox(height: screenHeight * 0.02),
                    // Next Button
                    MyButton1(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnBoardingScreen3(),
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
