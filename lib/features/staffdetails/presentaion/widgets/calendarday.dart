import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class CalendarDay extends StatelessWidget {
  final int day;
  final String? status;
  final bool isFuture;
  
  const CalendarDay({
    required this.day, 
    this.status,
    this.isFuture = false,
  });
 
  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = AppStyle.fontColor;
 
    if (!isFuture) {
      final s = status?.toLowerCase();
      if (s == 'present') {
        bgColor = const Color(0xFF22C55E); // Green
        textColor = Colors.white;
      } else if (s == 'absent') {
        bgColor = const Color(0xFFE53935); // Red
        textColor = Colors.white;
      }
      // Any other status (late, half-day, empty, etc.) falls back to default
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
              color: isFuture ? AppStyle.hintColor : textColor,
              weight: bgColor != null ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}