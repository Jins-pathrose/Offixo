class AttendanceRecord {
  final int attendanceId;
  final int memberId;
  final String empNo;
  final String employeeName;
  final String branchName;
  final String status;
  final String? checkinTime;
  final String? checkoutTime;
  final String workingHours;
  final int totalBreaksTaken;
  final String totalBreakDuration;

  const AttendanceRecord({
    required this.attendanceId,
    required this.memberId,
    required this.empNo,
    required this.employeeName,
    required this.branchName,
    required this.status,
    this.checkinTime,
    this.checkoutTime,
    required this.workingHours,
    required this.totalBreaksTaken,
    required this.totalBreakDuration,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      attendanceId: json['attendance_id'] as int,
      memberId: json['member_id'] as int,
      empNo: json['emp_no'] as String,
      employeeName: json['employee_name'] as String,
      branchName: json['branch_name'] as String,
      status: json['status'] as String,
      checkinTime: json['checkin_time'] as String?,
      checkoutTime: json['checkout_time'] as String?,
      workingHours: json['working_hours'] as String? ?? '00:00',
      totalBreaksTaken: json['total_breaks_taken'] as int? ?? 0,
      totalBreakDuration: json['total_break_duration'] as String? ?? '00:00:00',
    );
  }

  bool get isPresent => status == 'PRESENT';
  bool get isAbsent => status == 'ABSENT';
  bool get isLate => status == 'LATE';
}