import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? trailingLabel;
  final VoidCallback? onTrailingTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailingLabel,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppStyle.text(size: 16, weight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (trailingLabel != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTrailingTap,
            child: Text(
              trailingLabel!,
              style: AppStyle.text(
                size: 12,
                color: const Color(0xFF333B69),
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
