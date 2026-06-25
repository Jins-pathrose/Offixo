import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;
 
  const SectionHeader({
    required this.title,
    this.trailingLabel,
    this.onTrailingTap,
  });
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppStyle.text(size: 16, weight: FontWeight.w700),
        ),
        if (trailingLabel != null)
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailingLabel!,
              style: AppStyle.text(
                size: 12,
                color: Color(0xFF333B69),
                weight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}