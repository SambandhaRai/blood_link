import 'package:flutter/material.dart';

const Color _primaryRed = Color(0xFFC30026);

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      // Forces all items to display their labels
      type: BottomNavigationBarType.fixed,

      selectedItemColor: _primaryRed,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'Bricolage Grotesque',
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),

      // Text style for the unselected labels
      unselectedLabelStyle: const TextStyle(fontSize: 12),

      // The currently selected index (should be 0 for Home initially)
      currentIndex: currentIndex,
      // The callback when a tab is pressed
      onTap: onTap,

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_active_outlined),
          label: 'Requests',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
      ],
    );
  }
}
