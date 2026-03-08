import 'package:blood_link/app/theme/app_colors.dart';
import 'package:blood_link/core/api/api_endpoints.dart';
import 'package:blood_link/core/services/location/location_service.dart';
import 'package:blood_link/core/utils/distance_utils.dart';
import 'package:blood_link/features/request/domain/entities/request_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class OngoingDonationPage extends ConsumerStatefulWidget {
  const OngoingDonationPage({
    super.key,
    this.request,
    required this.personName,
    this.personProfileFileName,
    required this.onFinishRequest,
  });

  final RequestEntity? request;
  final String personName;
  final String? personProfileFileName;
  final Future<void> Function(String requestId) onFinishRequest;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OngoingDonationPageState();
}

class _OngoingDonationPageState extends ConsumerState<OngoingDonationPage> {
  bool _isFinishing = false;

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

  Future<void> _finishRequest() async {
    final requestId = widget.request?.requestId;
    if (requestId == null || requestId.isEmpty || _isFinishing) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Confirm Finish",
            style: TextStyle(fontFamily: "BricolageGrotesque SemiBold"),
          ),
          content: const Text(
            "Are you sure you want to mark this request as finished?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
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

    if (confirmed != true || !mounted) return;

    setState(() => _isFinishing = true);
    await widget.onFinishRequest(requestId);
    if (!mounted) return;
    setState(() => _isFinishing = false);
    Navigator.pop(context);
  }

  Future<void> callNumber(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phone';
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    if (request == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4ECEE),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: IconButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text(
            "Current Donation",
            style: TextStyle(
              fontFamily: "BricolageGrotesque Bold",
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 26,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.block, size: 90, color: Color(0xFF8E8E95)),
                        SizedBox(height: 16),
                        Text(
                          "No Current Donation\nAvailable",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8E8E95),
                            fontFamily: "BricolageGrotesque SemiBold",
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final condition = request.recipientCondition.name;
    final bloodGroup = request.recipientBlood?.bloodGroup ?? "-";
    final requestFor = request.requestFor.name.toUpperCase();
    final hospitalName = request.hospital?.name ?? "Unknown Hospital";
    final hospitalLocation = request.hospital?.location;
    final timeText = _timeAgo(request.updatedAt ?? request.createdAt);
    final patientName =
        request.patientName ?? request.receiver?.fullName ?? "-";
    final patientPhone =
        request.patientPhone ?? request.receiver?.phoneNumber ?? "-";
    final patientEmail = request.receiver?.email ?? "-";
    final profileUrl =
        widget.personProfileFileName != null &&
            widget.personProfileFileName!.isNotEmpty
        ? ApiEndpoints.profilePicture(widget.personProfileFileName!)
        : null;
    final savedLocation = ref.read(locationServiceProvider).getSavedLocation();
    final distanceText = savedLocation != null && hospitalLocation != null
        ? DistanceUtils.formatDistanceKm(
            DistanceUtils.haversineDistanceKm(
              fromLat: savedLocation.lat,
              fromLng: savedLocation.lng,
              toLat: hospitalLocation.latitude,
              toLng: hospitalLocation.longitude,
            ),
          )
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECEE),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Current Donation",
          style: TextStyle(
            fontFamily: "BricolageGrotesque Bold",
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.grey.shade100,
                            child: ClipOval(
                              child: profileUrl != null
                                  ? Image.network(
                                      profileUrl,
                                      width: 72,
                                      height: 72,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Icon(
                                        Icons.person_outline,
                                        size: 34,
                                        color: Colors.grey.shade500,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_outline,
                                      size: 34,
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
                                  "${widget.personName} [$bloodGroup]",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: "BricolageGrotesque SemiBold",
                                    fontSize: 25,
                                  ),
                                ),
                                Text(
                                  "Request For: $requestFor",
                                  style: const TextStyle(
                                    color: Color(0xFF667085),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        distanceText != null
                                            ? "$distanceText, $hospitalName"
                                            : hospitalName,
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                                if (timeText.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      "($timeText)",
                                      style: const TextStyle(
                                        color: Color(0xFF98A2B3),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "Recipient's Detail:",
                        style: TextStyle(
                          fontFamily: "BricolageGrotesque Bold",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        request.recipientDetails,
                        style: const TextStyle(
                          color: Color(0xFF1D2939),
                          fontSize: 16,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Condition:",
                        style: TextStyle(
                          fontFamily: "BricolageGrotesque Bold",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${condition[0].toUpperCase()}${condition.substring(1)}.",
                        style: const TextStyle(
                          color: Color(0xFF1D2939),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE4E7EC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Patient Info:",
                              style: TextStyle(
                                fontFamily: "BricolageGrotesque Bold",
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Patient Name",
                              style: TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              patientName,
                              style: const TextStyle(
                                color: Color(0xFF1D2939),
                                fontFamily: "BricolageGrotesque SemiBold",
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Patient Phone",
                              style: TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => callNumber(patientPhone),
                              child: Text(
                                patientPhone,
                                style: const TextStyle(
                                  color: Color(0xFF1D2939),
                                  fontFamily: "BricolageGrotesque SemiBold",
                                  fontSize: 15,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Patient Email",
                              style: TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              patientEmail,
                              style: const TextStyle(
                                color: Color(0xFF1D2939),
                                fontFamily: "BricolageGrotesque SemiBold",
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isFinishing ? null : _finishRequest,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFFB30717),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isFinishing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Finish",
                                  style: TextStyle(
                                    fontFamily: "BricolageGrotesque Bold",
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
