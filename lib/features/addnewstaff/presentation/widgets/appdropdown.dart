import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final TextEditingController? controller;
 
  const AppTextField({
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.onChanged,
    this.errorText,
    this.controller,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null
                  ? const Color(0xFFE53935)
                  : AppStyle.borderColor,
            ),
          ),
          child: TextField(
            controller: controller,
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
 
// ─────────────────────────────────────────────
//  WIDGET: App Dropdown
// ─────────────────────────────────────────────
class AppDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  /// Optional map of item value → display label.
  /// If not provided, the raw item value is shown.
  final Map<String, String>? itemLabels;
  final ValueChanged<String?>? onChanged;
  final String? errorText;

  const AppDropdown({
    required this.hint,
    required this.items,
    this.value,
    this.itemLabels,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure the current value exists in items to avoid Dropdown assertion errors
    final safeValue =
        (value != null && items.contains(value)) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: errorText != null
                  ? const Color(0xFFE53935)
                  : AppStyle.borderColor,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: safeValue,
              hint: Text(
                hint,
                style: AppStyle.text(size: 13, color: AppStyle.hintColor),
              ),
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: AppStyle.hintColor),
              style: AppStyle.text(size: 13),
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(itemLabels?[e] ?? e),
                      ))
                  .toList(),
              onChanged: onChanged,
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