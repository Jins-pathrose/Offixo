import 'package:offixoadmin/features/staffdetails/data/models/leaverecordmodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leavebalanceresponse.dart';

class LeaveDetails {
  final int pending;
  final int approved;
  final int rejected;
  final List<LeaveBalanceDetail> balances;
  final List<LeaveRecord> records;

  LeaveDetails({
    required this.pending,
    required this.approved,
    required this.rejected,
    required this.balances,
    required this.records,
  });
}