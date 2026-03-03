import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/services/location/location_service.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/request_card.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/status_card.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
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
            content: Text(
              "Enable location permission and GPS to fetch matched requests.",
            ),
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 80,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                    height: 60,
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
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TabBar(
                          onTap: (index) {
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
                            Tab(text: "Matched Requests"),
                            Tab(text: "All Requests"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _RequestList(
                              requestState: requestState,
                              onRetry: _loadMatchedRequests,
                            ),
                            _RequestList(
                              requestState: requestState,
                              onRetry: _loadAllPendingRequests,
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _RequestList extends StatelessWidget {
  final RequestState requestState;
  final VoidCallback onRetry;

  const _RequestList({required this.requestState, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final requests = [...requestState.requests]
      ..sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });

    if (requestState.status == RequestStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requestState.status == RequestStatus.error) {
      final errorText = requestState.errorMessage ?? 'Failed to load requests.';
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.primary,
                size: 40,
              ),
              const SizedBox(height: 10),
              Text(
                errorText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "BricolageGrotesque Medium",
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (requests.isEmpty) {
      return const Center(child: Text("No requests found."));
    }

    final groupedRequests = <DateTime, List<RequestEntity>>{};
    for (final req in requests) {
      final rawDate = req.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dayKey = DateTime(rawDate.year, rawDate.month, rawDate.day);
      groupedRequests.putIfAbsent(dayKey, () => []);
      groupedRequests[dayKey]!.add(req);
    }

    return ListView.separated(
      itemCount: groupedRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final date = groupedRequests.keys.elementAt(index);
        final dailyRequests = groupedRequests[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 0, 5),
              child: Text(
                _formatDateHeaderStatic(date),
                style: const TextStyle(
                  fontFamily: "BricolageGrotesque Medium",
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dailyRequests.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final req = dailyRequests[index];
                return RequestCard(
                  bloodGroup: req.recipientBlood!.bloodGroup,
                  requestStatus: req.requestStatus ?? "pending",
                  hospitalName: req.hospital!.name,
                  distance: "—",
                  profileFileName: req.receiver?.profilePicture,
                  fallbackLetter: (req.receiver?.fullName ?? "U").trim(),
                  onAccept: () {
                    // TODO: accept request
                  },
                  onDecline: () {
                    // TODO: decline request
                  },
                  onViewDetails: () {
                    // TODO: open details page
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDateHeaderStatic(DateTime date) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
