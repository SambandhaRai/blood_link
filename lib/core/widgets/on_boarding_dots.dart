import 'package:flutter/material.dart';

class OnBoardingDots extends StatelessWidget {
  const OnBoardingDots({super.key, required this.currentIndex});

  final int currentIndex; // page tracking

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 5),
          width: currentIndex == index ? 20 : 10,
          height: 10,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? Color(0xFFA72636)
                : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }
}
