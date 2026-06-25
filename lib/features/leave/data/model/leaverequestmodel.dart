class LeaveRequestModel {
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
  final String? reviewedByName;
  final String? rejectionReason;

  const LeaveRequestModel({
    required this.id,
    required this.member,
    required this.memberName,
    required this.memberEmpNo,
    required this.leaveType,
    required this.leaveTypeName,
    required this.fromDate,
    required this.toDate,
    required this.session,
    required this.numberOfDays,
    required this.reason,
    required this.status,
    required this.appliedAt,
    this.reviewedByName,
    this.rejectionReason,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      LeaveRequestModel(
        id: json['id'] ?? 0,
        member: json['member'] ?? 0,
        memberName: json['member_name'] ?? '',
        memberEmpNo: json['member_emp_no'] ?? '',
        leaveType: json['leave_type'] ?? 0,
        leaveTypeName: json['leave_type_name'] ?? '',
        fromDate: json['from_date'] ?? '',
        toDate: json['to_date'] ?? '',
        session: json['session'] ?? '',
        numberOfDays: json['number_of_days'] ?? '0',
        reason: json['reason'] ?? '',
        status: json['status'] ?? '',
        appliedAt: json['applied_at'] ?? '',
        reviewedByName: json['reviewed_by_name'],
        rejectionReason: json['rejection_reason'],
      );

  // "2026-06-15" → "15.06.2026"
  String _formatDate(String raw) {
    try {
      final parts = raw.split('-');
      return '${parts[2]}.${parts[1]}.${parts[0]}';
    } catch (_) {
      return raw;
    }
  }

  String get fromDateFormatted => _formatDate(fromDate);
  String get toDateFormatted => _formatDate(toDate);

  // "2026-06-09T17:18:15.504652+05:30" → "09.06.2026"
  String get appliedDateFormatted {
    try {
      return _formatDate(appliedAt.substring(0, 10));
    } catch (_) {
      return '--';
    }
  }

  String get sessionLabel {
    switch (session) {
      case 'FULL_DAY': return 'Full Day';
      case 'HALF_DAY_AM': return 'Half Day AM';
      case 'HALF_DAY_PM': return 'Half Day PM';
      default: return session;
    }
  }

  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';
}