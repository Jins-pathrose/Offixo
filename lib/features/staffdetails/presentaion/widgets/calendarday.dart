import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class CalendarDay extends StatelessWidget {
  final int day;
  final String? status;
  const CalendarDay({required this.day, this.status});
 
  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = AppStyle.fontColor;
 
    if (status == 'present') {
      bgColor = const Color(0xFF22C55E);
      textColor = Colors.white;
    } else if (status == 'absent' || status == 'late') {
      bgColor = const Color(0xFFE53935);
      textColor = Colors.white;
    }
 
    return Padding(
      padding: const EdgeInsets.all(2),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(
            '$day',
            style: AppStyle.text(
              size: 12,
              color: textColor,
              weight: bgColor != null ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}