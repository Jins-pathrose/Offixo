import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class EditTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.edit_outlined, size: 48, color: AppStyle.accentCyan),
          const SizedBox(height: 12),
          Text('Edit Staff',
              style: AppStyle.text(size: 16, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Edit functionality coming soon.',
              style: AppStyle.text(size: 13, color: AppStyle.hintColor),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}