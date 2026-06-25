class LeaveAnalyticsResponse {
  final bool success;
  final LeaveMeta meta;
  final YearlyStatusCounts yearlyStatusCounts;
  final List<MonthlyLeaveDetail> monthlyLeaveDetails;

  LeaveAnalyticsResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        meta = LeaveMeta.fromJson(json['meta'] ?? {}),
        yearlyStatusCounts = YearlyStatusCounts.fromJson(json['yearly_status_counts'] ?? {}),
        monthlyLeaveDetails = (json['monthly_leave_details'] as List?)
            ?.map((e) => MonthlyLeaveDetail.fromJson(e))
            .toList() ?? [];
}

class LeaveMeta {
  final int memberId;
  final String empNo;
  final int year;
  final int? monthFiltered;

  LeaveMeta.fromJson(Map<String, dynamic> json)
      : memberId = json['member_id'] ?? 0,
        empNo = json['emp_no'] ?? '',
        year = json['year'] ?? 0,
        monthFiltered = json['month_filtered'];
}

class YearlyStatusCounts {
  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;
  final int cancelledCount;

  YearlyStatusCounts.fromJson(Map<String, dynamic> json)
      : pendingCount = json['pending_count'] ?? 0,
        approvedCount = json['approved_count'] ?? 0,
        rejectedCount = json['rejected_count'] ?? 0,
        cancelledCount = json['cancelled_count'] ?? 0;
}

class MonthlyLeaveDetail {
  final int id;
  final int member;
  final String memberName;
  final String memberEmpNo;
  final int leaveType;
  final String leaveTypeName;
  final String fromDate;
  final String toDate;
  final String session;
  final String numberOfDays;
  final String reason;
  final String status;
  final String appliedAt;
  final int? reviewedBy;
  final String? reviewedByName;
  final String? reviewedAt;
  final String? rejectionReason;

  MonthlyLeaveDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        member = json['member'] ?? 0,
        memberName = json['member_name'] ?? '',
        memberEmpNo = json['member_emp_no'] ?? '',
        leaveType = json['leave_type'] ?? 0,
        leaveTypeName = json['leave_type_name'] ?? '',
        fromDate = json['from_date'] ?? '',
        toDate = json['to_date'] ?? '',
        session = json['session'] ?? '',
        numberOfDays = json['number_of_days']?.toString() ?? '0',
        reason = json['reason'] ?? '',
        status = json['status'] ?? '',
        appliedAt = json['applied_at'] ?? '',
        reviewedBy = json['reviewed_by'],
        reviewedByName = json['reviewed_by_name'],
        reviewedAt = json['reviewed_at'],
        rejectionReason = json['rejection_reason'];
}