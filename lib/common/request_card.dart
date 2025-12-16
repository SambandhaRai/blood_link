import 'package:blood_link/widgets/my_outlined_button.dart';
import 'package:flutter/material.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({
    super.key,
    required this.name,
    required this.donorId,
    required this.location,
    required this.distance,
    required this.image,
    required this.onAccept,
    required this.onDecline,
    required this.onViewDetails,
  });

  final String name;
  final String donorId;
  final String location;
  final String distance;
  final String image;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(radius: 30, backgroundImage: AssetImage(image)),

            const SizedBox(width: 12),

            // Expanding Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Bricolage Grotesque',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Donor ID
                  Text(
                    "Donor ID: $donorId",
                    style: const TextStyle(
                      fontFamily: 'Bricolage Grotesque',
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Location
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFFA72636),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "$distance, $location",
                          style: const TextStyle(
                            fontFamily: 'Bricolage Grotesque',
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // View Details
                  GestureDetector(
                    onTap: onViewDetails,
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        fontFamily: 'Bricolage Grotesque',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFA72636),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFFA72636),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA72636),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onAccept,
                  child: Text('Accept'),
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
