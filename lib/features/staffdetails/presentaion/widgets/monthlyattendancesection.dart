import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendance.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/calendarday.dart';

class MonthlyAttendanceSection extends StatelessWidget {
  final MonthlyAttendance? monthly;
  const MonthlyAttendanceSection({this.monthly});
 
  @override
  Widget build(BuildContext context) {
    final dayStatus = monthly?.dayStatus ?? {};
    const int totalDays  = 31;
    const int startWeekday = 0; // Sunday
 
    final cells = <Widget>[];
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (int day = 1; day <= totalDays; day++) {
      cells.add(CalendarDay(day: day, status: dayStatus[day]));
    }
 
    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final end = (i + 7).clamp(0, cells.length);
      final rowCells = List<Widget>.from(cells.sublist(i, end));
      while (rowCells.length < 7) rowCells.add(const SizedBox.shrink());
      rows.add(Row(children: rowCells.map((c) => Expanded(child: c)).toList()));
      rows.add(const SizedBox(height: 6));
    }
 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Monthly Attendance',
                style: AppStyle.text(size: 15, weight: FontWeight.w700)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00BCD4),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(monthly?.monthLabel ?? '--',
                      style: AppStyle.text(
                          size: 12, color: Colors.white, weight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  const Icon(Icons.calendar_month_outlined,
                      size: 14, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
 
        Row(
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
              .map((d) => Expanded(
                    child: Center(
                      child: Text(d,
                          style: AppStyle.text(
                              size: 11,
                              color: AppStyle.hintColor,
                              weight: FontWeight.w500)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
 
        Column(children: rows),
        const SizedBox(height: 16),
 
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: AppStyle.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Download Report',
                    style: AppStyle.text(
                        size: 14, color: Colors.white, weight: FontWeight.w600)),
                const SizedBox(width: 8),
                const Icon(Icons.download_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}