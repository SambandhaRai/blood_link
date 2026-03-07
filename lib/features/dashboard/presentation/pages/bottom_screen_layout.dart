import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/history_screen.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/home_screen.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/profile_screen.dart';
import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/request_screen.dart';
import 'package:blood_link/features/dashboard/presentation/state/bottom_nav_state.dart';
import 'package:blood_link/features/request/presentation/pages/ongoing_donation_page.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomScreenLayout extends ConsumerStatefulWidget {
  const BottomScreenLayout({super.key});

  @override
  ConsumerState<BottomScreenLayout> createState() => _BottomScreenLayoutState();
}

class _BottomScreenLayoutState extends ConsumerState<BottomScreenLayout> {
  List<Widget> listBottomScreen = [
    const HomeScreen(),
    const RequestScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  Future<void> _handleFinishFromShortcut(String requestId) async {
    await ref.read(requestViewModelProvider.notifier).finishRequest(requestId);
    if (!mounted) return;

    final state = ref.read(requestViewModelProvider);
    if (state.status == RequestStatus.error) {
      final error = state.errorMessage ?? "Failed to finish request.";
      SnackbarUtils.showError(context, error);
      return;
    }

    SnackbarUtils.showSuccess(context, "Request finished successfully.");
    await ref.read(requestViewModelProvider.notifier).getMyHistory();
  }

  Future<void> _openOngoingDonationFromAppBar() async {
    final userSessionService = ref.read(userSessionServiceProvider);
    final currentUserId = userSessionService.getCurrentUserId();

    if (currentUserId == null || currentUserId.isEmpty) {
      SnackbarUtils.showWarning(context, "User session not found.");
      return;
    }

    await ref.read(requestViewModelProvider.notifier).getMyHistory();
    if (!mounted) return;

    final requestState = ref.read(requestViewModelProvider);
    if (requestState.status == RequestStatus.error) {
      final error = requestState.errorMessage ?? "Failed to load history.";
      SnackbarUtils.showError(context, error);
      return;
    }

    final ongoingDonation = requestState.myOngoingRequests
        .where((request) => request.donorId == currentUserId)
        .toList();

    if (ongoingDonation.isEmpty) {
      SnackbarUtils.showInfo(context, "No ongoing donation found.");
      return;
    }

    final request = ongoingDonation.first;
    final personName = request.receiver?.fullName ?? "Unknown User";
    final profileFile = request.receiver?.profilePicture;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OngoingDonationPage(
          request: request,
          personName: personName,
          personProfileFileName: profileFile,
          onFinishRequest: _handleFinishFromShortcut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;
    final avatarSize = compact ? 44.0 : 52.0;
    final avatarInnerSize = compact ? 40.0 : 48.0;
    final iconSize = compact ? 28.0 : 36.0;
    final greetingFont = compact ? 20.0 : 25.0;

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
      appBar: selectedIndex == 0
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
                    Expanded(
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: avatarSize,
                                height: avatarSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: avatarInnerSize / 2,
                                  backgroundColor: Colors.white,
                                  child: ClipOval(
                                    child: (profileImageUrl != null)
                                        ? Image.network(
                                            profileImageUrl,
                                            width: avatarInnerSize,
                                            height: avatarInnerSize,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (_, error, stackTrace) =>
                                                    Center(
                                                      child: Text(
                                                        userName.isNotEmpty
                                                            ? userName[0]
                                                                  .toUpperCase()
                                                            : "U",
                                                        style: TextStyle(
                                                          fontSize: compact
                                                              ? 18
                                                              : 24,
                                                        ),
                                                      ),
                                                    ),
                                          )
                                        : Center(
                                            child: Text(
                                              userName.isNotEmpty
                                                  ? userName[0].toUpperCase()
                                                  : "U",
                                              style: TextStyle(
                                                fontSize: compact ? 18 : 24,
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
                          SizedBox(width: compact ? 6 : 10),
                          Expanded(
                            child: Text(
                              "Hi, $userName",
                              style: TextStyle(
                                fontFamily: 'BricolageGrotesque SemiBold',
                                fontSize: greetingFont,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.access_time,
                        size: iconSize,
                        color: Colors.white,
                      ),
                      onPressed: _openOngoingDonationFromAppBar,
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: listBottomScreen[selectedIndex],
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
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(bottomNavIndexProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}
