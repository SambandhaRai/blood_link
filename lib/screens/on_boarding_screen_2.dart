import 'package:blood_link/screens/on_boarding_screen_3.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:blood_link/widgets/on_boarding_dots.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen2 extends StatelessWidget {
  const OnBoardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/on_boarding_2.png'),
                    // Invisible Box
                    SizedBox(height: 10),
                    // Title
                    Text(
                      "Connect with the Right Donor",
                      style: TextStyle(
                        fontFamily: 'Bricolage Grotesque',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Invisible Box
                    SizedBox(height: 5),
                    // Subtitle
                    Text(
                      "We only show you blood requests that match your blood group for accurate and safe donations.",
                      style: TextStyle(
                        fontFamily: 'Bricolage Grotesque',
                        fontSize: 18,
                        fontWeight: FontWeight.w200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Dots Indicator
              OnBoardingDots(currentIndex: 1),
              // Invisible Box
              SizedBox(height: 20),
              // Invisible Box
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
            ],
          ),
        ),
      ),
    );
  }
}
