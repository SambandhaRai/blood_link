import 'package:flutter/material.dart';
import 'package:blood_link/app/theme/app_colors.dart';

class SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const SettingsCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            color: Colors.black.withAlpha((0.06 * 255).round()),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final Color? trailingTextColor;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailingText,
    this.trailingTextColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final showTrailingText = trailingText != null;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 26, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "BricolageGrotesque SemiBold",
                  fontSize: 16,
                ),
              ),
            ),
            if (showTrailingText)
              Text(
                trailingText!,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: trailingTextColor ?? AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 26, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: "BricolageGrotesque SemiBold",
                fontSize: 16,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withAlpha(100),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
