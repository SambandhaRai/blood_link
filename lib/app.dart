import 'package:blood_link/screens/splash_screen.dart';
import 'package:blood_link/theme/theme_data.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: getApplicationTheme(),
    );
  }
}
