import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class MultiSelectDropdown extends StatelessWidget {
  final String hint;
  final List<String> selectedValues;
  final List<String> items;
  final Map<String, String>? itemLabels;
  final ValueChanged<List<String>> onChanged;
  final String? errorText;

  const MultiSelectDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValues,
    required this.onChanged,
    this.itemLabels,
    this.errorText,
  });

  void _showSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        List<String> tempSelected = List.from(selectedValues);
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(hint, style: AppStyle.text(size: 16, weight: FontWeight.w600)),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final label = itemLabels?[item] ?? item;
                    final isSelected = tempSelected.contains(item);
                    return CheckboxListTile(
                      title: Text(label, style: AppStyle.text(size: 13)),
                      value: isSelected,
                      activeColor: AppStyle.primaryColor,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            tempSelected.add(item);
                          } else {
                            tempSelected.remove(item);
                          }
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Cancel', style: AppStyle.text(size: 14)),
                ),
                TextButton(
                  onPressed: () {
                    onChanged(tempSelected);
                    Navigator.pop(ctx);
                  },
                  child: Text('OK', style: AppStyle.text(size: 14, color: AppStyle.primaryColor)),
                ),
              ],
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showSelectionDialog(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: errorText != null
                    ? const Color(0xFFE53935)
                    : AppStyle.borderColor,
              ),
            ),
            child: selectedValues.isEmpty
                ? Text(
                    hint,
                    style: AppStyle.text(size: 13, color: AppStyle.hintColor),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedValues.map((value) {
                      final label = itemLabels?[value] ?? value;
                      return Chip(
                        label: Text(label, style: AppStyle.text(size: 12)),
                        onDeleted: () {
                          final newValues = List<String>.from(selectedValues)..remove(value);
                          onChanged(newValues);
                        },
                        deleteIcon: const Icon(Icons.close, size: 16),
                        backgroundColor: AppStyle.primaryColor.withOpacity(0.1),
                        side: BorderSide.none,
                      );
                    }).toList(),
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
