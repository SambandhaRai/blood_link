import 'package:blood_link/features/splash/presentation/pages/splash_page.dart';
import 'package:blood_link/app/theme/theme_data.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      theme: getApplicationTheme(),
    );
  }
}
