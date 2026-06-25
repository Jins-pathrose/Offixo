import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class SummaryBadge extends StatelessWidget {
  final int count;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final bool isActive;
  final VoidCallback onTap;
 
  const SummaryBadge({
    required this.count,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.isActive,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: isActive
                ? iconColor.withOpacity(0.08)
                : Colors.white,
            border: Border.all(
              color: isActive ? iconColor : borderColor,
              width: isActive ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${count.toString().padLeft(2, '0')}',
                      style: AppStyle.text(
                          size: 16, weight: FontWeight.w700)),
                  Text(label,
                      style: AppStyle.text(
                          size: 11, color: AppStyle.hintColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}