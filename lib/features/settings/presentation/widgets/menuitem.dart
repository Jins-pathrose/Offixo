import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;
  final bool isLast;
  final bool showChevron;
 
  const MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
    this.isLast = false,
    this.showChevron = true,
  });
 
  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppStyle.accentCyan;
    final effectiveLabelColor = labelColor ?? AppStyle.fontColor;
 
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: effectiveIconColor, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppStyle.text(
                  size: 14,
                  color: effectiveLabelColor,
                  weight: FontWeight.w500,
                ),
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: AppStyle.hintColor),
          ],
        ),
      ),
    );
  }
}