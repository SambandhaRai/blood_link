import 'package:blood_link/screens/on_boarding_screen_2.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen3 extends StatelessWidget {
  const OnBoardingScreen3({super.key});

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
                    Image.asset('assets/images/on_boarding_3.png'),
                    // Invisible Box
                    SizedBox(height: 10),
                    // Title
                    Text(
                      "Track Your Donations Effortlessly",
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
                      "Monitor your donation activity and stay updated on all requests in one place.",
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
              // Invisible Box
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
            ],
          ),
        ),
      ),
    );
  }
}
