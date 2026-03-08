import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/services/location/location_service.dart';
import 'package:blood_link/core/services/sensors/shake/shake_service.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/request/request_list.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/status_card.dart';
import 'package:blood_link/features/hospital/presentation/view_model/hospital_viewmodel.dart';
import 'package:blood_link/features/request/domain/entities/create_request_entity.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:blood_link/features/user/presentation/state/user_state.dart';
import 'package:blood_link/features/user/presentation/view_model/user_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  late final ShakeService _shakeService;
  double? _lat;
  double? _lng;
  int _currentTabIndex = 0;
  int _matchedPage = 1;
  int _allPage = 1;
  static const int _pageSize = 10;
  bool _shakeDialogOpen = false;
  DateTime? _lastShakeAt;

  @override
  void initState() {
    super.initState();
    _shakeService = ref.read(shakeServiceProvider);

    Future.microtask(() {
      ref.read(hospitalViewModelProvider.notifier).getAllHospitals();
      _loadMatchedRequests();
      _shakeService.startListening(onShake: _onPhoneShake);
    });
  }

  @override
  void dispose() {
    _shakeService.stopListening();
    super.dispose();
  }

  Future<void> _onPhoneShake() async {
    if (!mounted || _shakeDialogOpen) return;

    final now = DateTime.now();
    if (_lastShakeAt != null &&
        now.difference(_lastShakeAt!) < const Duration(seconds: 4)) {
      return;
    }
    _lastShakeAt = now;
    _shakeDialogOpen = true;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Post Emergency Request",
            style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
          ),
          content: const Text(
            "Phone shake detected. Do you want to post a blood request for yourself now?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text("Post Request"),
            ),
          ],
        );
      },
    );

    _shakeDialogOpen = false;
    if (confirmed != true || !mounted) return;
    await _postSelfRequestFromShake();
  }

  Future<void> _postSelfRequestFromShake() async {
    final session = ref.read(userSessionServiceProvider);
    final bloodId = session.getCurrentUserBloodId();
    final fullName = session.getCurrentUserFullName() ?? "User";
    final phone = session.getCurrentUserPhoneNumber() ?? "N/A";

    if (bloodId == null || bloodId.isEmpty) {
      SnackbarUtils.showError(
        context,
        "Your blood group is missing. Please update profile first.",
      );
      return;
    }

    String? hospitalId = _getFirstActiveHospitalId();
    if (hospitalId == null) {
      await ref.read(hospitalViewModelProvider.notifier).getAllHospitals();
      if (!mounted) return;
      hospitalId = _getFirstActiveHospitalId();
    }

    if (hospitalId == null) {
      SnackbarUtils.showError(
        context,
        "No active hospital found. Please add hospitals first.",
      );
      return;
    }

    final recipientDetails =
        "Emergency self request by $fullName. Contact: $phone.";

    await ref
        .read(requestViewModelProvider.notifier)
        .createRequests(
          recipientBloodId: bloodId,
          recipientDetails: recipientDetails,
          recipientCondition: ConditionType.critical,
          hospitalId: hospitalId,
          requestFor: RequestForType.self,
        );

    if (!mounted) return;
    final reqState = ref.read(requestViewModelProvider);
    if (reqState.status == RequestStatus.error) {
      SnackbarUtils.showError(
        context,
        reqState.errorMessage ?? "Failed to post emergency request.",
      );
      return;
    }

    SnackbarUtils.showSuccess(
      context,
      "Emergency request posted successfully.",
    );
    await _loadMatchedRequests(page: 1);
  }

  String? _getFirstActiveHospitalId() {
    final hospitals = ref.read(hospitalViewModelProvider).hospitals;
    for (final hospital in hospitals) {
      if (hospital.isActive) return hospital.id;
    }
    return null;
  }

  Future<void> _loadMatchedRequests({int? page}) async {
    final coords = await _getCoordinates();
    if (!mounted) return;

    if (coords == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enable location permission fetch matched requests."),
        ),
      );
      return;
    }

    final nextPage = page ?? _matchedPage;
    _matchedPage = nextPage;
    await ref
        .read(requestViewModelProvider.notifier)
        .getMatchedRequests(
          lat: coords.lat,
          lng: coords.lng,
          page: nextPage,
          size: _pageSize,
        );
  }

  Future<void> _loadAllPendingRequests({int? page}) async {
    final nextPage = page ?? _allPage;
    _allPage = nextPage;

    if (!mounted) return;

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
    if (_currentTabIndex == 0) {
      await _loadMatchedRequests(page: _matchedPage);
      return;
    }
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
                                _loadMatchedRequests(page: _matchedPage);
                              } else {
                                _loadAllPendingRequests(page: _allPage);
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
                                  onRetry: () =>
                                      _loadMatchedRequests(page: _matchedPage),
                                  onAcceptRequest: _handleAcceptRequest,
                                ),
                                RequestList(
                                  requestState: requestState,
                                  onRetry: () =>
                                      _loadAllPendingRequests(page: _allPage),
                                  onAcceptRequest: _handleAcceptRequest,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (requestState.status == RequestStatus.loaded &&
                            requestState.totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: requestState.page > 1
                                        ? () {
                                            if (_currentTabIndex == 0) {
                                              _loadMatchedRequests(
                                                page: requestState.page - 1,
                                              );
                                            } else {
                                              _loadAllPendingRequests(
                                                page: requestState.page - 1,
                                              );
                                            }
                                          }
                                        : null,
                                    child: const Text("Previous"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    "Page ${requestState.page} / ${requestState.totalPages}",
                                    style: const TextStyle(
                                      fontFamily: "BricolageGrotesque SemiBold",
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        requestState.page <
                                            requestState.totalPages
                                        ? () {
                                            if (_currentTabIndex == 0) {
                                              _loadMatchedRequests(
                                                page: requestState.page + 1,
                                              );
                                            } else {
                                              _loadAllPendingRequests(
                                                page: requestState.page + 1,
                                              );
                                            }
                                          }
                                        : null,
                                    child: const Text("Next"),
                                  ),
                                ),
                              ],
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
