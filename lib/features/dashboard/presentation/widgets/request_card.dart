import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.bloodGroup,
    required this.requestStatus,
    required this.hospitalName,
    required this.distance,

    this.profileFileName,
    required this.fallbackLetter,

    this.onAccept,
    required this.onViewDetails,
  });

  final String bloodGroup;
  final String requestStatus;
  final String hospitalName;
  final String distance;

  final String? profileFileName;
  final String fallbackLetter;

  final VoidCallback? onAccept;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final compact = screenWidth < 380;
    final avatarRadius = compact ? 24.0 : 30.0;
    final avatarSize = compact ? 48.0 : 60.0;
    final actionFontSize = compact ? 12.0 : 14.0;

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Network profile picture
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
                    bloodGroup,
                    style: TextStyle(
                      fontFamily: 'Bricolage Grotesque',
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onViewDetails,
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        color: Color(0xFFA72636),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              width: compact ? 92 : 106,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
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
                  const SizedBox(height: 2),
                  OutlinedButton(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
