import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leaverecordmodel.dart';

class LeaveRow extends StatelessWidget {
  final LeaveRecord record;
  const LeaveRow({required this.record});
 
  @override
  Widget build(BuildContext context) {
    final isApproved = record.status == 'Approved';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(record.date, style: AppStyle.text(size: 12))),
          Expanded(child: Text(record.type, style: AppStyle.text(size: 12))),
          Expanded(
            child: Text(record.status,
                style: AppStyle.text(
                  size: 12,
                  color: isApproved
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFE53935),
                  weight: FontWeight.w500,
                )),
          ),
          Expanded(
            child: Icon(Icons.remove_red_eye_outlined,
                size: 18, color: AppStyle.accentCyan),
          ),
        ],
      ),
    );
  }
}