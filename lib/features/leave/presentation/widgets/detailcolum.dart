import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class DetailCol extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
 
  const DetailCol({
    required this.label,
    required this.value,
    this.valueColor,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppStyle.text(
                size: 11, color: AppStyle.accentCyan)),
        const SizedBox(height: 3),
        Text(value,
            style: AppStyle.text(
              size: 13,
              weight: FontWeight.w600,
              color: valueColor,
            )),
      ],
    );
  }
}