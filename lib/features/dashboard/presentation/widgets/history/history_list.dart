import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:blood_link/core/utils/snackbar_utils.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/history/history_card.dart';
import 'package:blood_link/features/dashboard/presentation/widgets/history/history_details.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:blood_link/features/request/presentation/pages/edit_request_page.dart';
import 'package:blood_link/features/request/presentation/pages/ongoing_donation_page.dart';
import 'package:blood_link/features/request/presentation/state/request_state.dart';
import 'package:blood_link/features/request/presentation/view_model/request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HistoryTabType { ongoing, received, donated }

class HistoryList extends ConsumerWidget {
  const HistoryList({
    super.key,
    required this.title,
    required this.requestState,
    required this.requests,
    required this.onRetry,
    required this.tabType,
    required this.onFinishRequest,
  });

  final String title;
  final RequestState requestState;
  final List<RequestEntity> requests;
  final VoidCallback onRetry;
  final HistoryTabType tabType;
  final Future<void> Function(String requestId) onFinishRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (requestState.status == RequestStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (requestState.status == RequestStatus.error) {
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
                requestState.errorMessage ?? "Failed to load history.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 14),
              ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
            ],
          ),
        ),
      );
    }

    final sorted = [...requests]
      ..sort((a, b) {
        final aDate = a.updatedAt ?? a.createdAt ?? DateTime(1970);
        final bDate = b.updatedAt ?? b.createdAt ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });

    if (sorted.isEmpty) {
      return Center(child: Text(title));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: sorted.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final req = sorted[index];
        final currentUserId = ref
            .read(userSessionServiceProvider)
            .getCurrentUserId();
        final isDonatingOngoing =
            tabType == HistoryTabType.ongoing &&
            currentUserId != null &&
            req.donorId == currentUserId;
        final status = (req.requestStatus ?? "").toLowerCase().trim();
        final canEdit =
            tabType == HistoryTabType.ongoing &&
            !isDonatingOngoing &&
            status != "accepted" &&
            status != "finished";
        final canDelete =
            !isDonatingOngoing &&
            status != "accepted" &&
            req.requestId != null &&
            req.requestId!.isNotEmpty;

        final personName = tabType == HistoryTabType.received
            ? (req.donor?.fullName ?? "Unknown User")
            : (req.receiver?.fullName ?? "Unknown User");
        final profileFile = tabType == HistoryTabType.received
            ? req.donor?.profilePicture
            : req.receiver?.profilePicture;

        return HistoryCard(
          request: req,
          personName: personName,
          personProfileFileName: profileFile,
          showFinish: isDonatingOngoing,
          showEdit: canEdit,
          showDelete: canDelete,
          onEdit: canEdit
              ? () async {
                  final updated = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRequestPage(request: req),
                    ),
                  );

                  if (updated == true) {
                    await ref
                        .read(requestViewModelProvider.notifier)
                        .getMyHistory();
                  }
                }
              : null,
          onDelete: canDelete
              ? () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "Delete Request",
                          style: TextStyle(
                            fontFamily: "BricolageGrotesque SemiBold",
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to delete this request?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmed != true) return;

                  await ref
                      .read(requestViewModelProvider.notifier)
                      .deleteRequest(req.requestId!);

                  if (!context.mounted) return;

                  final nextState = ref.read(requestViewModelProvider);
                  if (nextState.status == RequestStatus.error) {
                    SnackbarUtils.showError(
                      context,
                      nextState.errorMessage ?? "Failed to delete request.",
                    );
                    return;
                  }

                  SnackbarUtils.showSuccess(
                    context,
                    "Request deleted successfully.",
                  );
                  await ref
                      .read(requestViewModelProvider.notifier)
                      .getMyHistory();
                }
              : null,
          onFinish: isDonatingOngoing && req.requestId != null
              ? () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          "Confirm Finish",
                          style: TextStyle(
                            fontFamily: "BricolageGrotesque SemiBold",
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to mark this request as finished?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text("Yes, Finish"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirmed == true) {
                    await onFinishRequest(req.requestId!);
                  }
                }
              : null,
          onViewDetails: () {
            final userIdLabel = tabType == HistoryTabType.received
                ? "Donor ID"
                : "Receiver ID";
            final userIdValue = tabType == HistoryTabType.received
                ? req.donor?.userId
                : req.receiver?.userId;

            if (isDonatingOngoing) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OngoingDonationPage(
                    request: req,
                    personName: personName,
                    personProfileFileName: profileFile,
                    onFinishRequest: onFinishRequest,
                  ),
                ),
              );
              return;
            }

            HistoryDetailsDialog.show(
              context,
              request: req,
              personName: personName,
              personProfileFileName: profileFile,
              canFinish: isDonatingOngoing,
              onFinishRequest: onFinishRequest,
              userIdLabel: userIdLabel,
              userIdValue: userIdValue,
            );
          },
        );
      },
    );
  }
}
