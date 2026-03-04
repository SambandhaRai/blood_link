import 'package:blood_link/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'status_item.dart';

class StatusCard extends ConsumerStatefulWidget {
  const StatusCard({super.key});

  @override
  ConsumerState<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends ConsumerState<StatusCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardHeight = screenWidth < 360 ? 84.0 : 96.0;
    final iconSize = screenWidth < 360 ? 40.0 : 50.0;

    final userSessionService = ref.read(userSessionServiceProvider);
    final bloodGroupName =
        userSessionService.getCurrentUserBloodGroupName() ?? "Unknown";

    return Card(
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: cardHeight,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StatusItem(
                  icon: SvgPicture.asset(
                    'assets/icons/blood_group_icon.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  status: bloodGroupName,
                  label: 'Blood Group',
                ),
              ),
              Expanded(
                child: StatusItem(
                  icon: SvgPicture.asset(
                    'assets/icons/donor_status_icon.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  status: 'Allowed',
                  label: 'Donor Status',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
