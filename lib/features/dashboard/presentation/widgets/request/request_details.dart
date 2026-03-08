import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:flutter/material.dart';

class RequestDetailsDialog extends StatelessWidget {
  const RequestDetailsDialog({
    super.key,
    required this.request,
    required this.personName,
    this.personProfileFileName,
    this.distanceText,
    required this.canAccept,
    required this.onAcceptRequest,
  });

  final RequestEntity request;
  final String personName;
  final String? personProfileFileName;
  final String? distanceText;
  final bool canAccept;
  final Future<void> Function(String requestId) onAcceptRequest;

  static Future<void> show(
    BuildContext context, {
    required RequestEntity request,
    required String personName,
    String? personProfileFileName,
    String? distanceText,
    required bool canAccept,
    required Future<void> Function(String requestId) onAcceptRequest,
  }) async {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => RequestDetailsDialog(
        request: request,
        personName: personName,
        personProfileFileName: personProfileFileName,
        distanceText: distanceText,
        canAccept: canAccept,
        onAcceptRequest: onAcceptRequest,
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
    final receiverId = request.receiver?.userId;

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
                                fontFamily: "BricolageGrotesque Bold",
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Request For: $requestFor",
                              style: TextStyle(
                                color: const Color(0xFF667085),
                                fontSize: compact ? 14 : 16,
                                fontFamily: "BricolageGrotesque Medium",
                              ),
                            ),
                            if (receiverId != null &&
                                receiverId.isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                "Receiver ID: $receiverId",
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
                                  fontFamily: "BricolageGrotesque SemiBold",
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
                  if (distanceText != null && distanceText!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Distance: $distanceText",
                        style: TextStyle(
                          color: const Color(0xFF667085),
                          fontSize: compact ? 12 : 13,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    "Recipient's Detail:",
                    style: TextStyle(
                      fontFamily: "BricolageGrotesque Bold",
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
                      fontFamily: "BricolageGrotesque Bold",
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
                            fontFamily: "BricolageGrotesque Bold",
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
                            fontFamily: "BricolageGrotesque SemiBold",
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
                            fontFamily: "BricolageGrotesque SemiBold",
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
                            fontFamily: "BricolageGrotesque SemiBold",
                            fontSize: compact ? 14 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      if (canAccept && request.requestId != null) ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await onAcceptRequest(request.requestId!);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: const Color(0xFFB30717),
                            ),
                            child: const Text("Accept"),
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
                          child: Text(canAccept ? "Close" : "Back"),
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
