import 'package:blood_link/screens/login_screen.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen4 extends StatelessWidget {
  const OnBoardingScreen4({super.key});

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
                    Image.asset('assets/images/on_boarding_4.png'),
                    // Invisible Box
                    SizedBox(height: 10),
                    // Title
                    Text(
                      "Request Blood Instantly",
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
                      "A safe, trusted way to connect with donors during critical moments.",
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
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                text: "Get Started",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
