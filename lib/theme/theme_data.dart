import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: "BricolageGrotesque Regular",
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA72636),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        textStyle: TextStyle(
          fontFamily: 'BricolageGrotesque SemiBold',
          fontSize: 20,
          color: Colors.white,
        ),
        foregroundColor: Colors.white,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFFA72636),
      unselectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(fontFamily: "BricolageGrotesque Bold"),
      elevation: 10,
    ),
  );
}
