import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leavedetailsmodel.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/leavebalanceitem.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/leavecountbadge.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/leaverow.dart';

class LeaveTab extends StatelessWidget {
  final LeaveDetails? leave;
  const LeaveTab({this.leave});
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leave Details',
                  style: AppStyle.text(size: 15, weight: FontWeight.w700)),
              const SizedBox(height: 14),
 
              Row(children: [
                LeaveCountBadge(
                  count: leave?.pending ?? 0,
                  label: 'Pending',
                  icon: Icons.pending_outlined,
                  iconColor: const Color(0xFFFF9800),
                  borderColor: const Color(0xFFFFE0B2),
                ),
                const SizedBox(width: 10),
                LeaveCountBadge(
                  count: leave?.approved ?? 0,
                  label: 'Approved',
                  icon: Icons.check_circle_outline,
                  iconColor: const Color(0xFF22C55E),
                  borderColor: const Color(0xFF22C55E),
                ),
                const SizedBox(width: 10),
                LeaveCountBadge(
                  count: leave?.rejected ?? 0,
                  label: 'Rejected',
                  icon: Icons.cancel_outlined,
                  iconColor: const Color(0xFFE53935),
                  borderColor: const Color(0xFFFFCDD2),
                ),
              ]),
              const SizedBox(height: 16),
 
              Row(
                children: ['Date', 'Type', 'Status', 'Details']
                    .map((h) => Expanded(
                          child: Text(h,
                              style: AppStyle.text(
                                  size: 12,
                                  color: AppStyle.accentCyan,
                                  weight: FontWeight.w600)),
                        ))
                    .toList(),
              ),
              const Divider(height: 16),
 
              ...?(leave?.records.map((r) => LeaveRow(record: r)).toList()),
            ],
          ),
        ),
 
        const SizedBox(height: 16),
 
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leave Balance',
                  style: AppStyle.text(size: 15, weight: FontWeight.w700)),
              const Divider(height: 20),
              Row(children: [
                LeaveBalanceItem(
                    label: 'Casual Leave',
                    count: leave?.casualLeaveBalance ?? 0),
                const SizedBox(width: 32),
                LeaveBalanceItem(
                    label: 'Sick Leave',
                    count: leave?.sickLeaveBalance ?? 0),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}