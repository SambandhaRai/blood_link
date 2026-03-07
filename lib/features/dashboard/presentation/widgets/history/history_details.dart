import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:flutter/material.dart';

class HistoryDetailsDialog extends StatelessWidget {
  const HistoryDetailsDialog({
    super.key,
    required this.request,
    required this.personName,
    this.personProfileFileName,
    required this.userIdLabel,
    this.userIdValue,
    required this.canFinish,
    required this.onFinishRequest,
  });

  final RequestEntity request;
  final String personName;
  final String? personProfileFileName;
  final String userIdLabel;
  final String? userIdValue;
  final bool canFinish;
  final Future<void> Function(String requestId) onFinishRequest;

  static Future<void> show(
    BuildContext context, {
    required RequestEntity request,
    required String personName,
    String? personProfileFileName,
    required String userIdLabel,
    String? userIdValue,
    required bool canFinish,
    required Future<void> Function(String requestId) onFinishRequest,
  }) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => HistoryDetailsDialog(
        request: request,
        personName: personName,
        personProfileFileName: personProfileFileName,
        userIdLabel: userIdLabel,
        userIdValue: userIdValue,
        canFinish: canFinish,
        onFinishRequest: onFinishRequest,
      ),
    );
  }

  Color _conditionColor(String value) {
    switch (value.toLowerCase()) {
      case "critical":
        return const Color(0xFFEF4444);
      case "urgent":
        return const Color(0xFFF59E0B);
      case "stable":
        return const Color(0xFF22C55E);
      default:
        return Colors.grey;
    }
  }

  String _timeAgo(DateTime? date) {
    if (date == null) return "";
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) {
      return "${diff.inHours} hour${diff.inHours > 1 ? "s" : ""} ago";
    }
    if (diff.inDays == 1) return "yesterday";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;
    final maxDialogWidth = compact ? screenWidth - 28 : 380.0;

    final bloodGroup = request.recipientBlood?.bloodGroup ?? "-";
    final hospitalName = request.hospital?.name ?? "Unknown Hospital";
    final condition = request.recipientCondition.name;
    final requestFor = request.requestFor.name.toUpperCase();
    final ribbonColor = _conditionColor(condition);
    final timeText = _timeAgo(request.updatedAt ?? request.createdAt);
    final patientName =
        request.patientName ?? request.receiver?.fullName ?? "-";
    final patientPhone =
        request.patientPhone ?? request.receiver?.phoneNumber ?? "-";
    final patientEmail = request.receiver?.email ?? "-";

    final profileUrl =
        personProfileFileName != null && personProfileFileName!.isNotEmpty
        ? ApiEndpoints.profilePicture(personProfileFileName!)
        : null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: compact ? 14 : 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxDialogWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 12 : 16,
                compact ? 12 : 16,
                compact ? 12 : 16,
                compact ? 12 : 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: ribbonColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 30),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: compact ? 26 : 30,
                        backgroundColor: Colors.grey.shade100,
                        child: ClipOval(
                          child: profileUrl != null
                              ? Image.network(
                                  profileUrl,
                                  width: compact ? 52 : 60,
                                  height: compact ? 52 : 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => Icon(
                                    Icons.person_outline,
                                    size: compact ? 28 : 32,
                                    color: Colors.grey.shade500,
                                  ),
                                )
                              : Icon(
                                  Icons.person_outline,
                                  size: compact ? 28 : 32,
                                  color: Colors.grey.shade500,
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$personName [$bloodGroup]",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: compact ? 20 : 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Request For: $requestFor",
                              style: TextStyle(
                                color: const Color(0xFF667085),
                                fontSize: compact ? 14 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (userIdValue != null &&
                                userIdValue!.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                "$userIdLabel: $userIdValue",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: compact ? 12 : 13,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hospitalName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: compact ? 16 : 17,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF344054),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (timeText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            timeText,
                            style: TextStyle(
                              color: const Color(0xFF667085),
                              fontSize: compact ? 12 : 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Recipient's Detail:",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 16 : 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    request.recipientDetails,
                    style: TextStyle(
                      color: const Color(0xFF344054),
                      fontSize: compact ? 14 : 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Condition:",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: compact ? 16 : 17,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    condition[0].toUpperCase() + condition.substring(1),
                    style: TextStyle(
                      color: const Color(0xFF344054),
                      fontSize: compact ? 14 : 15,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 12 : 16,
                      vertical: compact ? 12 : 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE4E7EC)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Patient Info:",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: compact ? 16 : 17,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Patient Name",
                          style: TextStyle(
                            color: const Color(0xFF667085),
                            fontSize: compact ? 14 : 15,
                          ),
                        ),
                        Text(
                          patientName,
                          style: TextStyle(
                            color: const Color(0xFF1D2939),
                            fontWeight: FontWeight.w600,
                            fontSize: compact ? 14 : 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Patient Phone",
                          style: TextStyle(
                            color: const Color(0xFF667085),
                            fontSize: compact ? 14 : 15,
                          ),
                        ),
                        Text(
                          patientPhone,
                          style: TextStyle(
                            color: const Color(0xFF1D2939),
                            fontWeight: FontWeight.w600,
                            fontSize: compact ? 14 : 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Patient Email",
                          style: TextStyle(
                            color: const Color(0xFF667085),
                            fontSize: compact ? 14 : 15,
                          ),
                        ),
                        Text(
                          patientEmail,
                          style: TextStyle(
                            color: const Color(0xFF1D2939),
                            fontWeight: FontWeight.w600,
                            fontSize: compact ? 14 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      if (canFinish && request.requestId != null) ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await onFinishRequest(request.requestId!);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: const Color(0xFFB30717),
                            ),
                            child: const Text("Finish"),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(canFinish ? "Close" : "Delete"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
