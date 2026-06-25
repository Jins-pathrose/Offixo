import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class FormFields extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;
 
  const FormFields({
    required this.label,
    required this.child,
    this.isRequired = false,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
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
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}