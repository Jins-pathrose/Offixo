import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class LeaveCountBadge extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
 
  const LeaveCountBadge({
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
  });
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count',
                    style:
                        AppStyle.text(size: 16, weight: FontWeight.w700)),
                Text(label,
                    style: AppStyle.text(size: 11, color: AppStyle.hintColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}