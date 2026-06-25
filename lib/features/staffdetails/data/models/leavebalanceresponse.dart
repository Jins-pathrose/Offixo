class LeaveBalanceResponse {
  final bool success;
  final int year;
  final int memberId;
  final List<LeaveBalanceDetail> leaveBalanceDetails;

  LeaveBalanceResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        year = json['year'] ?? 0,
        memberId = json['member_id'] ?? 0,
        leaveBalanceDetails = (json['leave_balance_details'] as List?)
            ?.map((e) => LeaveBalanceDetail.fromJson(e))
            .toList() ?? [];
}

class LeaveBalanceDetail {
  final int leaveTypeId;
  final String leaveTypeName;
  final String leaveTypeCode;
  final double totalAllocated;
  final double usedDays;
  final double remainingDays;

  LeaveBalanceDetail.fromJson(Map<String, dynamic> json)
      : leaveTypeId = json['leave_type_id'] ?? 0,
        leaveTypeName = json['leave_type_name'] ?? '',
        leaveTypeCode = json['leave_type_code'] ?? '',
        totalAllocated = (json['total_allocated'] ?? 0).toDouble(),
        usedDays = (json['used_days'] ?? 0).toDouble(),
        remainingDays = (json['remaining_days'] ?? 0).toDouble();
}