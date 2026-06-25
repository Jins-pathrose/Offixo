import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class LeaveBalanceItem extends StatelessWidget {
  final String label;
  final int count;
  const LeaveBalanceItem({required this.label, required this.count});
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppStyle.text(size: 12, color: AppStyle.hintColor)),
        const SizedBox(height: 4),
        Text('$count',
            style: AppStyle.text(size: 20, weight: FontWeight.w700)),
      ],
    );
  }
}