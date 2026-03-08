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
    this.showEdit = false,
    this.showDelete = false,
    required this.onViewDetails,
    this.onFinish,
    this.onEdit,
    this.onDelete,
  });

  final RequestEntity request;
  final String personName;
  final String? personProfileFileName;
  final bool showFinish;
  final bool showEdit;
  final bool showDelete;
  final VoidCallback onViewDetails;
  final VoidCallback? onFinish;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;

    final cardPadding = compact ? 8.0 : 14.0;
    final avatarRadius = compact ? 24.0 : 30.0;
    final avatarSize = compact ? 48.0 : 60.0;
    final titleFontSize = compact ? 14.0 : 15.0;
    final smallFontSize = compact ? 11.0 : 12.0;
    final actionFontSize = compact ? 11.0 : 12.0;

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
    final status = showFinish
        ? "pending"
        : (request.requestStatus ?? "pending").trim();
    final statusLabel = status.isEmpty
        ? "Pending"
        : "${status[0].toUpperCase()}${status.substring(1)}";

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
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
                  radius: avatarRadius,
                  backgroundColor: Colors.grey.shade100,
                  child: ClipOval(
                    child: profileUrl != null
                        ? Image.network(
                            profileUrl,
                            width: avatarSize,
                            height: avatarSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.person_outline,
                              size: compact ? 24 : 30,
                              color: Colors.grey.shade500,
                            ),
                          )
                        : Icon(
                            Icons.person_outline,
                            size: compact ? 24 : 30,
                            color: Colors.grey.shade500,
                          ),
                  ),
                ),
                SizedBox(width: compact ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$personName [$bloodGroup]",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: "BricolageGrotesque Bold",
                          fontSize: titleFontSize,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "For: $requestFor",
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Status: $statusLabel",
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Colors.black87,
                          fontFamily: "BricolageGrotesque SemiBold",
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: const Color(0xFFA72636),
                            size: compact ? 15 : 16,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              timeText.isNotEmpty
                                  ? "$hospitalName ($timeText)"
                                  : hospitalName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: smallFontSize),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 10 : 12),
            const Text(
              "Recipient's Detail:",
              style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
            ),
            const SizedBox(height: 4),
            Text(
              request.recipientDetails,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black87,
                fontSize: compact ? 12 : 13,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Condition:",
              style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
            ),
            const SizedBox(height: 4),
            Text(
              condition[0].toUpperCase() + condition.substring(1),
              style: TextStyle(
                color: Colors.black87,
                fontSize: compact ? 12 : 13,
              ),
            ),
            SizedBox(height: compact ? 12 : 14),
            Row(
              children: [
                if (showFinish) ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onFinish,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: compact ? 8 : 10,
                          horizontal: compact ? 6 : 10,
                        ),
                      ),
                      child: Text(
                        "Finish",
                        style: TextStyle(
                          fontFamily: "BricolageGrotesque Bold",
                          fontSize: actionFontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: compact ? 6 : 8),
                ],
                if (showEdit) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onEdit,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: compact ? 8 : 10,
                          horizontal: compact ? 6 : 10,
                        ),
                      ),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          fontFamily: "BricolageGrotesque Bold",
                          fontSize: actionFontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: compact ? 4 : 6),
                ],
                if (showDelete) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDelete,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: compact ? 8 : 10,
                          horizontal: compact ? 6 : 10,
                        ),
                      ),
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          fontFamily: "BricolageGrotesque Bold",
                          fontSize: actionFontSize,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: compact ? 4 : 6),
                ],
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: compact ? 8 : 10,
                        horizontal: compact ? 6 : 10,
                      ),
                    ),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        fontFamily: "BricolageGrotesque Bold",
                        fontSize: actionFontSize,
                      ),
                    ),
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
