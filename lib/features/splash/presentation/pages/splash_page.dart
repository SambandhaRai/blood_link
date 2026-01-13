import 'dart:async';
import 'package:blood_link/app/routes/app_routes.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen_layout.dart';
import 'package:blood_link/features/onboarding/presentation/pages/on_boarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    // check if user is already logged in
    final userSessionService = ref.read(userSessionServiceProvider);
    final isLoggedIn = userSessionService.isUserLoggedIn();

    if (isLoggedIn) {
      AppRoutes.pushReplacement(context, BottomScreenLayout());
    } else {
      AppRoutes.pushReplacement(context, OnBoardingPage());
    }
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
