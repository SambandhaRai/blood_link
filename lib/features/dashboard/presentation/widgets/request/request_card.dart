import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.bloodGroup,
    required this.requestStatus,
    required this.recipientCondition,
    required this.hospitalName,
    required this.distance,
    required this.recipientDetails,

    this.profileFileName,
    required this.fallbackLetter,

    this.onAccept,
    required this.onViewDetails,
  });

  final String bloodGroup;
  final String requestStatus;
  final String recipientCondition;
  final String hospitalName;
  final String distance;
  final String recipientDetails;

  final String? profileFileName;
  final String fallbackLetter;

  final VoidCallback? onAccept;
  final VoidCallback onViewDetails;

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;
    final avatarRadius = compact ? 24.0 : 30.0;
    final avatarSize = compact ? 48.0 : 60.0;
    final actionFontSize = compact ? 12.0 : 14.0;
    final ribbonColor = _conditionColor(recipientCondition);

    final profileImageUrl =
        (profileFileName != null && profileFileName!.isNotEmpty)
        ? ApiEndpoints.profilePicture(profileFileName!)
        : null;

    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(compact ? 8 : 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: (profileImageUrl != null)
                        ? Image.network(
                            profileImageUrl,
                            width: avatarSize,
                            height: avatarSize,
                            fit: BoxFit.cover,
                            errorBuilder: (_, error, stackTrace) => Center(
                              child: Text(
                                fallbackLetter.isNotEmpty
                                    ? fallbackLetter[0].toUpperCase()
                                    : "U",
                                style: TextStyle(fontSize: compact ? 18 : 22),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              fallbackLetter.isNotEmpty
                                  ? fallbackLetter[0].toUpperCase()
                                  : "U",
                              style: TextStyle(fontSize: compact ? 18 : 22),
                            ),
                          ),
                  ),
                ),
                SizedBox(width: compact ? 8 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$fallbackLetter [$bloodGroup]",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: compact ? 14 : 15,
                          fontFamily: "BricolageGrotesque SemiBold",
                        ),
                      ),
                      Text(
                        "Status: $requestStatus",
                        style: TextStyle(
                          fontSize: compact ? 11 : 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color(0xFFA72636),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "$distance, $hospitalName",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: compact ? 11 : 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "Recipient's Detail:",
              style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
            ),
            const SizedBox(height: 4),
            Text(
              recipientDetails,
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
              recipientCondition[0].toUpperCase() +
                  recipientCondition.substring(1),
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: compact ? 8 : 10,
                        horizontal: compact ? 6 : 10,
                      ),
                    ),
                    onPressed: onAccept,
                    child: Text(
                      "Accept",
                      style: TextStyle(fontSize: actionFontSize),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
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
                      style: TextStyle(fontSize: actionFontSize),
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
