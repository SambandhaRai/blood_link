import 'package:flutter/material.dart';

class StatusItem extends StatelessWidget {
  final Widget icon;
  final String status;
  final String label;

  const StatusItem({
    super.key,
    required this.icon,
    required this.status,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final iconGap = screenWidth < 360 ? 6.0 : 10.0;
    final statusFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final labelFontSize = screenWidth < 360 ? 12.0 : 14.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        SizedBox(width: iconGap),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'BricolageGrotesque Bold',
                  fontSize: statusFontSize,
                  color: Colors.black,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'BricolageGrotesque Light',
                  fontSize: labelFontSize,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
