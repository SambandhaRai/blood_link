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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: const TextStyle(
                fontFamily: 'BricolageGrotesque Bold',
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'BricolageGrotesque Light',
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
