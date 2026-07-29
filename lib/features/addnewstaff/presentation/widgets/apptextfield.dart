import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
 
  const AppTextField({
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.errorText,
    this.controller,
    this.initialValue,
    this.enabled = true,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null
                  ? const Color(0xFFE53935)
                  : AppStyle.borderColor,
            ),
          ),
          child: TextFormField(
            enabled: enabled,
            controller: controller,
            initialValue: initialValue,
            onChanged: onChanged,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: AppStyle.text(size: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppStyle.text(size: 13, color: AppStyle.hintColor),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text(
              errorText!,
              style: AppStyle.text(
                  size: 11, color: const Color(0xFFE53935)),
            ),
          ),
      ],
    );
  }
}