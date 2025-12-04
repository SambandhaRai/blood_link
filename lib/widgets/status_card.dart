import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'status_item.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        height: 90,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StatusItem(
                  icon: SvgPicture.asset(
                    'assets/icons/blood_group_icon.svg',
                    width: 50,
                    height: 50,
                  ),
                  status: 'O+',
                  label: 'Blood Group',
                ),
              ),
              Expanded(
                child: StatusItem(
                  icon: SvgPicture.asset(
                    'assets/icons/donor_status_icon.svg',
                    width: 50,
                    height: 50,
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
