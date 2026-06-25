import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class FieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;
  const FieldLabel({required this.label, this.isRequired = false});
 
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppStyle.text(size: 13, weight: FontWeight.w500),
        children: isRequired
            ? [
                TextSpan(
                  text: ' *',
                  style: AppStyle.text(
                      size: 13, color: const Color(0xFFE53935)),
                )
              ]
            : [],
      ),
    );
  }
}