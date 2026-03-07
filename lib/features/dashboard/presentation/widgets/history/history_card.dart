import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    super.key,
    required this.request,
    required this.personName,
    this.personProfileFileName,
    required this.showFinish,
    required this.onViewDetails,
    this.onFinish,
  });

  final RequestEntity request;
  final String personName;
  final String? personProfileFileName;
  final bool showFinish;
  final VoidCallback onViewDetails;
  final VoidCallback? onFinish;

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
    if (diff.inDays < 7) return "${diff.inDays} days ago";

    final d = date.day.toString().padLeft(2, "0");
    final m = date.month.toString().padLeft(2, "0");
    return "$d/$m/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final condition = request.recipientCondition.name;
    final ribbonColor = _conditionColor(condition);
    final profileUrl =
        personProfileFileName != null && personProfileFileName!.isNotEmpty
        ? ApiEndpoints.profilePicture(personProfileFileName!)
        : null;

    final bloodGroup = request.recipientBlood?.bloodGroup ?? "-";
    final hospitalName = request.hospital?.name ?? "Unknown Hospital";
    final timeText = _timeAgo(request.updatedAt ?? request.createdAt);
    final requestFor = request.requestFor.name.toUpperCase();

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: ribbonColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade100,
                  child: ClipOval(
                    child: profileUrl != null
                        ? Image.network(
                            profileUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.person_outline,
                              size: 30,
                              color: Colors.grey.shade500,
                            ),
                          )
                        : Icon(
                            Icons.person_outline,
                            size: 30,
                            color: Colors.grey.shade500,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$personName [$bloodGroup]",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: "BricolageGrotesque Bold",
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "For: $requestFor",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFA72636),
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              hospitalName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          if (timeText.isNotEmpty)
                            Text(
                              "($timeText)",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              "Recipient's Detail:",
              style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
            ),
            const SizedBox(height: 4),
            Text(
              request.recipientDetails,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 10),
            const Text(
              "Condition:",
              style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
            ),
            const SizedBox(height: 4),
            Text(
              condition[0].toUpperCase() + condition.substring(1),
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                if (showFinish) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onFinish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F1D1D),
                      ),
                      child: const Text("Finish"),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewDetails,
                    child: const Text("View Details"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
