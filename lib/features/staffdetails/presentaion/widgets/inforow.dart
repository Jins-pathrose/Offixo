import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
 
  const InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ 
              Icon(icon, size: 16, color: AppStyle.hintColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppStyle.text(
                            size: 12, color: AppStyle.accentCyan)),
                    const SizedBox(height: 3),
                    Text(value,
                        style: AppStyle.text(
                            size: 14, weight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, thickness: 0.5),
      ],
    );
  }
}