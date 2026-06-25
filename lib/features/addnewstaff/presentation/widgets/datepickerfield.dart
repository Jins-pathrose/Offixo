import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class DatePickerField extends StatelessWidget {
  final String hint;
  final DateTime? selectedDate;
  final ValueChanged<DateTime>? onDateSelected;
  final String? errorText;
 
  const DatePickerField({
    required this.hint,
    this.selectedDate,
    this.onDateSelected,
    this.errorText,
  });
 
  String _format(DateTime d) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1950),
              lastDate: DateTime(2100),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppStyle.accentCyan,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) onDateSelected?.call(picked);
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: errorText != null
                    ? const Color(0xFFE53935)
                    : AppStyle.borderColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null ? _format(selectedDate!) : hint,
                    style: AppStyle.text(
                      size: 13,
                      color: selectedDate != null
                          ? AppStyle.fontColor
                          : AppStyle.hintColor,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_month_outlined,
                    size: 18, color: AppStyle.hintColor),
              ],
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