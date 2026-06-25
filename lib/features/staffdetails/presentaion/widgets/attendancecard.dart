import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class AttendanceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color labelColor;
 
  const AttendanceCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.labelColor,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppStyle.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppStyle.text(size: 11, color: labelColor)),
                const SizedBox(height: 2),
                Text(value,
                    style: AppStyle.text(size: 14, weight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.more_vert, size: 16, color: AppStyle.hintColor),
        ],
      ),
    );
  }
}