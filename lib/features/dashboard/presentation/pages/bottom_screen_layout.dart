import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/history_screen.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/home_screen.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomScreenLayout extends ConsumerStatefulWidget {
  const BottomScreenLayout({super.key});

  @override
  ConsumerState<BottomScreenLayout> createState() => _BottomScreenLayoutState();
}

class _BottomScreenLayoutState extends ConsumerState<BottomScreenLayout> {
  int _selectedIndex = 0;

  List<Widget> listBottomScreen = [
    const HomeScreen(),
    const RequestScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.watch(userSessionServiceProvider);

    final userName = userSessionService
        .getCurrentUserFullName()!
        .split(" ")
        .first;
    final profileFileName = userSessionService.getCurrentUserProfilePicture();
    final profileImageUrl =
        (profileFileName != null && profileFileName.isNotEmpty)
        ? ApiEndpoints.profilePicture(profileFileName)
        : null;

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFFA72636),
              elevation: 0,
              toolbarHeight: 80,
              titleSpacing: 0,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white,
                                child: ClipOval(
                                  child: (profileImageUrl != null)
                                      ? Image.network(
                                          profileImageUrl,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Center(
                                            child: Text(
                                              userName.isNotEmpty
                                                  ? userName[0].toUpperCase()
                                                  : "U",
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            userName.isNotEmpty
                                                ? userName[0].toUpperCase()
                                                : "U",
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.check_circle,
                                color: Colors.lightGreenAccent,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Hi, $userName",
                          style: TextStyle(
                            fontFamily: 'BricolageGrotesque SemiBold',
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.access_time,
                            size: 36,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            size: 36,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: listBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined, size: 30),
            label: "Requests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time, size: 30),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 30),
            label: "Account",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
