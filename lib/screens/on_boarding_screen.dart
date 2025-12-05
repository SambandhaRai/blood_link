import 'package:blood_link/screens/login_screen.dart';
import 'package:blood_link/widgets/my_button_1.dart';
import 'package:blood_link/widgets/on_boarding_dots.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/on_boarding_1.png",
      "title": "Save Lives with a Single Tap",
      "subtitle":
          "A secure and fast platform connecting blood donors with people in need.",
    },
    {
      "image": "assets/images/on_boarding_2.png",
      "title": "Connect with the Right Donor",
      "subtitle":
          "We only show you blood requests that match your blood group for accurate and safe donations.",
    },
    {
      "image": "assets/images/on_boarding_3.png",
      "title": "Track Your Donations Effortlessly",
      "subtitle":
          "Monitor your donation activity and stay updated on all requests in one place.",
    },
    {
      "image": "assets/images/on_boarding_4.png",
      "title": "Request Blood Instantly",
      "subtitle":
          "A safe, trusted way to connect with donors during critical moments.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // TOP CONTENT (image + texts)
              Expanded(
                flex: 7,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (context, index) {
                    final item = onboardingData[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // IMAGE
                        Flexible(
                          flex: 5,
                          child: Image.asset(
                            item["image"]!,
                            height: screenHeight * 0.40,
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // TITLE
                        Flexible(
                          flex: 2,
                          child: Text(
                            item["title"]!,
                            style: const TextStyle(
                              fontFamily: 'Bricolage Grotesque',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        // SUBTITLE
                        Flexible(
                          flex: 2,
                          child: Text(
                            item["subtitle"]!,
                            style: const TextStyle(
                              fontFamily: 'Bricolage Grotesque',
                              fontSize: 18,
                              fontWeight: FontWeight.w200,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // BOTTOM SECTION (dots + button)
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OnBoardingDots(currentIndex: _currentIndex),

                    SizedBox(height: screenHeight * 0.02),

                    MyButton1(
                      onPressed: () {
                        if (_currentIndex == onboardingData.length - 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      text: _currentIndex == onboardingData.length - 1
                          ? "Get Started"
                          : "Next",
                    ),

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
