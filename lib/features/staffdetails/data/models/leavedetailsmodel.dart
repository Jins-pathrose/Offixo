import 'package:offixoadmin/features/staffdetails/data/models/leaverecordmodel.dart';

class LeaveDetails {
  final int pending;
  final int approved;
  final int rejected;
  final int casualLeaveBalance;
  final int sickLeaveBalance;
  final List<LeaveRecord> records;

  LeaveDetails({
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.casualLeaveBalance,
    required this.sickLeaveBalance,
    required this.records,
  });
}