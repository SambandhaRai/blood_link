import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/widgets/my_outlined_button.dart';
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

    required this.onAccept,
    required this.onDecline,
    required this.onViewDetails,
  });

  final String bloodGroup;
  final String requestStatus;
  final String hospitalName;
  final String distance;

  final String? profileFileName;
  final String fallbackLetter;

  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final profileImageUrl =
        (profileFileName != null && profileFileName!.isNotEmpty)
        ? ApiEndpoints.profilePicture(profileFileName!)
        : null;

    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Network profile picture
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: ClipOval(
                child: (profileImageUrl != null)
                    ? Image.network(
                        profileImageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            fallbackLetter.isNotEmpty
                                ? fallbackLetter[0].toUpperCase()
                                : "U",
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          fallbackLetter.isNotEmpty
                              ? fallbackLetter[0].toUpperCase()
                              : "U",
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bloodGroup,
                    style: const TextStyle(
                      fontFamily: 'Bricolage Grotesque',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Status: $requestStatus",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                          style: const TextStyle(fontSize: 12),
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

            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA72636),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onAccept,
                  child: const Text("Accept"),
                ),
                const SizedBox(height: 8),
                MyOutlinedButton(onPressed: onDecline, text: "Decline"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
