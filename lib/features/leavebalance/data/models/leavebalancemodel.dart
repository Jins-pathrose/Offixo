class LeaveBalanceModel {
  final String leaveTypeName;
  final String leaveTypeCode;
  final double totalAllocated;
  final double usedLeaves;
  final double remainingBalance;

  const LeaveBalanceModel({
    required this.leaveTypeName,
    required this.leaveTypeCode,
    required this.totalAllocated,
    required this.usedLeaves,
    required this.remainingBalance,
  });

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      leaveTypeName: json['leave_type_name']?.toString() ?? '',
      leaveTypeCode: json['leave_type_code']?.toString() ?? '',
      totalAllocated: (json['total_allocated'] as num?)?.toDouble() ?? 0,
      usedLeaves: (json['used_leaves'] as num?)?.toDouble() ?? 0,
      remainingBalance:
          (json['remaining_balance'] as num?)?.toDouble() ?? 0,
    );
  }

  // For a progress bar — fraction of allocated leave that's been used
  double get usedFraction =>
      totalAllocated == 0 ? 0 : (usedLeaves / totalAllocated).clamp(0, 1);
}

class EmployeeLeaveBalance {
  final int memberId;
  final String empNo;
  final String fullName;
  final String branchName;
  final String designation;
  final List<LeaveBalanceModel> balances;

  const EmployeeLeaveBalance({
    required this.memberId,
    required this.empNo,
    required this.fullName,
    required this.branchName,
    required this.designation,
    required this.balances,
  });

  factory EmployeeLeaveBalance.fromJson(Map<String, dynamic> json) {
    return EmployeeLeaveBalance(
      memberId: json['member_id'] as int? ?? 0,
      empNo: json['emp_no']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      branchName: json['branch_name']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      balances: (json['balances'] as List? ?? [])
          .map((e) => LeaveBalanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Totals across all leave types
  double get totalAllocated =>
      balances.fold(0.0, (sum, b) => sum + b.totalAllocated);

  double get totalUsed =>
      balances.fold(0.0, (sum, b) => sum + b.usedLeaves);

  double get totalRemaining =>
      balances.fold(0.0, (sum, b) => sum + b.remainingBalance);
}