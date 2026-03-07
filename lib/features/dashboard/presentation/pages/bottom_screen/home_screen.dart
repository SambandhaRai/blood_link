import 'package:blood_link/features/dashboard/presentation/pages/bottom_screen/request_screen.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/request/request_list.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/status_card.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/request/presentation/pages/request_blood_page.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:blood_link/features/user/presentation/state/user_state.dart';
import 'package:blood_link/features/user/presentation/view_model/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _allPage = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadAllPendingRequests(page: 1);
    });
  }

  Future<void> _loadAllPendingRequests({int? page}) async {
    final nextPage = page ?? _allPage;
    _allPage = nextPage;
    await ref
        .read(requestViewModelProvider.notifier)
        .getAllPendingRequests(page: nextPage, size: _pageSize);
  }

  Future<void> _handleAcceptRequest(String requestId) async {
    await ref.read(userViewmodelProvider.notifier).getCurrentUserProfile();
    if (!mounted) return;

    final userState = ref.read(userViewmodelProvider);
    if (userState.status == UserStatus.error) {
      SnackbarUtils.showError(
        context,
        userState.errorMessage ?? "Failed to validate active request.",
      );
      return;
    }

    final activeAcceptedRequestId = userState.user?.activeAcceptedRequestId;
    if (activeAcceptedRequestId != null &&
        activeAcceptedRequestId.isNotEmpty &&
        activeAcceptedRequestId != requestId) {
      SnackbarUtils.showWarning(
        context,
        "You can accept only one request at a time. Finish your active request first.",
      );
      return;
    }

    final shouldAccept = await _showAcceptConfirmation();
    if (!shouldAccept || !mounted) return;

    await ref.read(requestViewModelProvider.notifier).acceptRequest(requestId);
    if (!mounted) return;

    final updatedState = ref.read(requestViewModelProvider);
    if (updatedState.status == RequestStatus.error) {
      SnackbarUtils.showError(
        context,
        updatedState.errorMessage ?? "Failed to accept request.",
      );
      return;
    }

    SnackbarUtils.showSuccess(context, "Request accepted successfully.");
    await _loadAllPendingRequests(page: _allPage);
  }

  Future<bool> _showAcceptConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Accept Request",
            style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
          ),
          content: const Text("Are you sure you want to accept this request?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Accept"),
            ),
          ],
        );
      },
    );

    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestViewModelProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final compact = screenWidth < 380;
        final topHeaderHeight = compact ? 68.0 : 80.0;
        final logoSize = compact ? 100.0 : 140.0;

        Widget actionTile({
          required String icon,
          required String label,
          required VoidCallback onTap,
        }) {
          return InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SvgPicture.asset(
                    icon,
                    width: compact ? 38 : 50,
                    height: compact ? 38 : 50,
                  ),
                  SizedBox(width: compact ? 8 : 10),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Bricolage Grotesque',
                        fontSize: compact ? 15 : 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 15),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: topHeaderHeight,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFA72636),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 10,
                    left: 10,
                    right: 10,
                    child: StatusCard(),
                  ),
                ],
              ),
              SizedBox(height: compact ? 14 : 20),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(compact ? 10 : 12),
                    child: compact
                        ? Column(
                            children: [
                              actionTile(
                                icon: 'assets/icons/find_donor_icon.svg',
                                label: "Find Donors",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RequestBloodPage(),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              actionTile(
                                icon: 'assets/icons/donate_blood_icon.svg',
                                label: "Donate Blood",
                                onTap: () {},
                              ),
                              const SizedBox(height: 8),
                              Image.asset(
                                'assets/images/small_logo.png',
                                width: logoSize,
                                height: logoSize,
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 150,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      actionTile(
                                        icon:
                                            'assets/icons/find_donor_icon.svg',
                                        label: "Find Donors",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RequestBloodPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      actionTile(
                                        icon:
                                            'assets/icons/donate_blood_icon.svg',
                                        label: "Donate Blood",
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RequestScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  'assets/images/small_logo.png',
                                  width: logoSize,
                                  height: logoSize,
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  color: const Color.fromARGB(255, 248, 248, 248),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Requests",
                              style: TextStyle(
                                fontFamily: 'Bricolage Grotesque',
                                fontSize: compact ? 18 : 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 15),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RequestList(
                          requestState: requestState,
                          onRetry: () =>
                              _loadAllPendingRequests(page: _allPage),
                          onAcceptRequest: _handleAcceptRequest,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          maxItems: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
