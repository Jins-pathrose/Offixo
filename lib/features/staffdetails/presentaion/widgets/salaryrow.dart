import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class SalaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
 
  const SalaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppStyle.text(size: 13, color: AppStyle.hintColor)),
        Text(value,
            style: AppStyle.text(
                size: 14,
                weight: isBold ? FontWeight.w700 : FontWeight.w500)),
      ],
    );
  }
}