import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/services/location/location_service.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/request_list.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/status_card.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  double? _lat;
  double? _lng;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadMatchedRequests();
    });
  }

  Future<void> _loadMatchedRequests() async {
    final coords = await _getCoordinates();
    if (coords == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Enable location permission fetch matched requests."),
          ),
        );
      }
      return;
    }
    await ref
        .read(requestViewModelProvider.notifier)
        .getMatchedRequests(lat: coords.lat, lng: coords.lng);
  }

  Future<void> _loadAllPendingRequests() async {
    await ref.read(requestViewModelProvider.notifier).getAllPendingRequests();
  }

  Future<void> _handleAcceptRequest(String requestId) async {
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
    if (_currentTabIndex == 0) {
      await _loadMatchedRequests();
      return;
    }
    await _loadAllPendingRequests();
  }

  Future<SavedLocation?> _getCoordinates() async {
    if (_lat != null && _lng != null) {
      return SavedLocation(lat: _lat!, lng: _lng!);
    }

    final locationService = ref.read(locationServiceProvider);
    final result = await locationService.requestAndStoreCurrentLocation();
    final location = result.location ?? locationService.getSavedLocation();

    if (location == null) {
      return null;
    }

    _lat = location.lat;
    _lng = location.lng;

    return location;
  }

  @override
  Widget build(BuildContext context) {
    final requestState = ref.watch(requestViewModelProvider);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;
    final statusHeaderHeight = compact ? 50.0 : 60.0;
    final tabLabelSize = compact ? 12.0 : 14.0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 80,
        titleSpacing: 0,
        title: Text(
          "Requests",
          style: TextStyle(
            fontFamily: "BricolageGrotesque SemiBold",
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: statusHeaderHeight,
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
                    top: 0,
                    left: 10,
                    right: 10,
                    child: StatusCard(),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, compact ? 44 : 50, 10, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            labelStyle: TextStyle(
                              fontFamily: "BricolageGrotesque Medium",
                              fontSize: tabLabelSize,
                            ),
                            onTap: (index) {
                              _currentTabIndex = index;
                              if (index == 0) {
                                _loadMatchedRequests();
                              } else {
                                _loadAllPendingRequests();
                              }
                            },
                            labelColor: AppColors.primary,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: AppColors.primary,
                            tabs: const [
                              Tab(
                                child: FittedBox(
                                  child: Text("Matched Requests"),
                                ),
                              ),
                              Tab(
                                child: FittedBox(child: Text("All Requests")),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                RequestList(
                                  requestState: requestState,
                                  onRetry: _loadMatchedRequests,
                                  onAcceptRequest: _handleAcceptRequest,
                                ),
                                RequestList(
                                  requestState: requestState,
                                  onRetry: _loadAllPendingRequests,
                                  onAcceptRequest: _handleAcceptRequest,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
