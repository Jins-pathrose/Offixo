import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/leave/data/model/leaverequestmodel.dart';

class LeaveCard extends StatelessWidget {
  final LeaveRequestModel leave;
  final VoidCallback onViewTap;
 
  const LeaveCard({required this.leave, required this.onViewTap});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                leave.memberName.isNotEmpty
                    ? leave.memberName[0].toUpperCase()
                    : '?',
                style: AppStyle.text(
                    size: 18,
                    color: AppStyle.accentCyan,
                    weight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
 
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(leave.memberName,
                    style: AppStyle.text(
                        size: 14, weight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                  '${leave.leaveTypeName} • ${leave.memberEmpNo}',
                  style: AppStyle.text(
                      size: 11, color: AppStyle.hintColor),
                ),
              ],
            ),
          ),
 
          // View button
          GestureDetector(
            onTap: onViewTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppStyle.accentCyan.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppStyle.accentCyan.withOpacity(0.3)),
              ),
              child: Text('View',
                  style: AppStyle.text(
                      size: 12,
                      color: AppStyle.accentCyan,
                      weight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}