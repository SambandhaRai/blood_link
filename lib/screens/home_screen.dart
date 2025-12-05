import 'package:blood_link/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
            ),
            const SizedBox(height: 20),
            const Text("This is Home Screen", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
