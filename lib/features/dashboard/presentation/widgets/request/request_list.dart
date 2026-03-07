import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/services/location/location_service.dart';
import 'package:blood_link/core/utils/distance_utils.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/request/request_card.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/request/request_details.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestList extends ConsumerWidget {
  final RequestState requestState;
  final VoidCallback onRetry;
  final Future<void> Function(String requestId) onAcceptRequest;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int? maxItems;

  const RequestList({
    super.key,
    required this.requestState,
    required this.onRetry,
    required this.onAcceptRequest,
    this.shrinkWrap = false,
    this.physics,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedLocation = ref.read(locationServiceProvider).getSavedLocation();

    final requests = [...requestState.requests]
      ..sort((a, b) {
        final aDate = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
    final limitedRequests = maxItems != null
        ? requests.take(maxItems!).toList()
        : requests;

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

    if (limitedRequests.isEmpty) {
      return const Center(child: Text("No requests found."));
    }

    final groupedRequests = <DateTime, List<RequestEntity>>{};
    for (final req in limitedRequests) {
      final rawDate = req.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final dayKey = DateTime(rawDate.year, rawDate.month, rawDate.day);
      groupedRequests.putIfAbsent(dayKey, () => []);
      groupedRequests[dayKey]!.add(req);
    }

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: groupedRequests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final date = groupedRequests.keys.elementAt(index);
        final dailyRequests = groupedRequests[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
              child: Text(
                _formatDateHeaderStatic(date),
                style: const TextStyle(
                  fontFamily: "BricolageGrotesque Medium",
                  fontSize: 15,
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
                final requestId = req.requestId;
                final isPending =
                    (req.requestStatus ?? "").toLowerCase() == "pending";
                final canAccept =
                    isPending && requestId != null && requestId.isNotEmpty;

                final hospitalLocation = req.hospital?.location;
                final distanceText =
                    savedLocation != null && hospitalLocation != null
                    ? DistanceUtils.formatDistanceKm(
                        DistanceUtils.haversineDistanceKm(
                          fromLat: savedLocation.lat,
                          fromLng: savedLocation.lng,
                          toLat: hospitalLocation.latitude,
                          toLng: hospitalLocation.longitude,
                        ),
                      )
                    : "—";

                return RequestCard(
                  bloodGroup: req.recipientBlood?.bloodGroup ?? "-",
                  requestStatus: req.requestStatus ?? "pending",
                  recipientCondition: req.recipientCondition.name,
                  hospitalName: req.hospital?.name ?? "Unknown Hospital",
                  distance: distanceText,
                  recipientDetails: req.recipientDetails,
                  profileFileName: req.receiver?.profilePicture,
                  fallbackLetter: (req.receiver?.fullName ?? "U").trim(),
                  onAccept: canAccept ? () => onAcceptRequest(requestId) : null,
                  onViewDetails: () {
                    RequestDetailsDialog.show(
                      context,
                      request: req,
                      personName: req.receiver?.fullName ?? "Unknown User",
                      personProfileFileName: req.receiver?.profilePicture,
                      distanceText: distanceText,
                      canAccept: canAccept,
                      onAcceptRequest: onAcceptRequest,
                    );
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
