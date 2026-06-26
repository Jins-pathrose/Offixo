import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendance.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/calendarday.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/core/utils/pdf_service.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';

class MonthlyAttendanceSection extends StatelessWidget {
  final MonthlyAttendance? monthly;
  final int selectedMonth;
  final int selectedYear;
  final Function(int month, int year)? onMonthChanged;

  const MonthlyAttendanceSection({
    this.monthly,
    required this.selectedMonth,
    required this.selectedYear,
    this.onMonthChanged,
  });
 
  Future<void> _showMonthPicker(BuildContext context) async {
    final now = DateTime.now();
    int tempMonth = selectedMonth;
    int tempYear = selectedYear;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Month', style: AppStyle.text(size: 16, weight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        onPressed: () => setState(() => tempYear--),
                      ),
                      Text('$tempYear', style: AppStyle.text(size: 16, weight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: tempYear < now.year ? () => setState(() => tempYear++) : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (index) {
                      final month = index + 1;
                      final isSelected = month == tempMonth;
                      final isFuture = tempYear == now.year && month > now.month;
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      return InkWell(
                        onTap: isFuture ? null : () {
                          setState(() => tempMonth = month);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00BCD4) : (isFuture ? Colors.grey.shade200 : Colors.transparent),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? const Color(0xFF00BCD4) : Colors.grey.shade300),
                          ),
                          child: Text(
                            months[index],
                            style: AppStyle.text(
                              size: 12,
                              color: isSelected ? Colors.white : (isFuture ? Colors.grey.shade400 : Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: AppStyle.text(size: 14, color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onMonthChanged != null) {
                      onMonthChanged!(tempMonth, tempYear);
                    }
                  },
                  child: Text('Apply', style: AppStyle.text(size: 14, color: const Color(0xFF00BCD4), weight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
 
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthLabel = monthly?.monthLabel != null && monthly!.monthLabel != '--' 
        ? monthly!.monthLabel 
        : months[selectedMonth - 1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Monthly Attendance',
                style: AppStyle.text(size: 15, weight: FontWeight.w700)),
            GestureDetector(
              onTap: () => _showMonthPicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(monthLabel,
                        style: AppStyle.text(
                            size: 12, color: Colors.white, weight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    const Icon(Icons.calendar_month_outlined,
                        size: 14, color: Colors.white),
                  ],
                ),
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
          onTap: () async {
            final provider = context.read<StaffDetailsProvider>();
            final data = provider.monthlyAttendance;
            if (data == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No data available to download.')),
              );
              return;
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Generating PDF...')),
            );

            final path = await PdfService.generateAndSaveMonthlyAttendancePdf(data);

            if (context.mounted) {
              if (path != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Report saved to $path', style: const TextStyle(fontSize: 12))),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to download report.')),
                );
              }
            }
          },
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