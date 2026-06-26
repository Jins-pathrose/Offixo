import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendance.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/attendancecard.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/monthlyattendancesection.dart';

class AttendanceTabContent extends StatelessWidget {
  final AttendanceSummary? summary;
  final MonthlyAttendance? monthly;
  final int selectedMonth;
  final int selectedYear;
  final Function(int month, int year)? onMonthChanged;

  const AttendanceTabContent({
    this.summary,
    this.monthly,
    required this.selectedMonth,
    required this.selectedYear,
    this.onMonthChanged,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Today's Attendance",
              style: AppStyle.text(size: 15, weight: FontWeight.w700)),
          const SizedBox(height: 14),
 
          Row(children: [
            Expanded(
              child: AttendanceCard(
                icon: Icons.login_rounded,
                iconColor: const Color(0xFF22C55E),
                label: 'Check-in',
                value: summary?.checkIn ?? '--',
                labelColor: const Color(0xFF22C55E),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AttendanceCard(
                icon: Icons.logout_rounded,
                iconColor: const Color(0xFFE53935),
                label: 'Check-Out',
                value: summary?.checkOut ?? '--',
                labelColor: const Color(0xFFE53935),
              ),
            ),
          ]),
          const SizedBox(height: 12),
 
          Row(children: [
            Expanded(
              child: AttendanceCard(
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFF00ACC1),
                label: 'Total Worked',
                value: summary?.totalWorked ?? '--',
                labelColor: const Color(0xFF00ACC1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AttendanceCard(
                icon: Icons.watch_later_outlined,
                iconColor: const Color(0xFFFF9800),
                label: 'Overtime',
                value: summary?.overtime ?? '--',
                labelColor: const Color(0xFFFF9800),
              ),
            ),
          ]),
 
          if (summary?.isLateCheckIn == true) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_filled,
                      color: Color(0xFFE53935), size: 20),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Late Check-in',
                          style: AppStyle.text(
                              size: 13,
                              color: const Color(0xFFE53935),
                              weight: FontWeight.w600)),
                      Text(summary?.lateByText ?? '',
                          style: AppStyle.text(
                              size: 11, color: const Color(0xFFE57373))),
                    ],
                  ),
                ],
              ),
            ),
          ],
 
          const SizedBox(height: 20),
          MonthlyAttendanceSection(
            monthly: monthly,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            onMonthChanged: onMonthChanged,
          ),
        ],
      ),
    );
  }
}