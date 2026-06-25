class MonthlyAttendanceResponse {
  final bool success;
  final MemberInfo memberInfo;
  final int month;
  final int year;
  final String saturdayRuleApplied;
  final List<CalendarDayData> calendarData;

  MonthlyAttendanceResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        memberInfo = MemberInfo.fromJson(json['member_info'] ?? {}),
        month = json['month'] ?? 0,
        year = json['year'] ?? 0,
        saturdayRuleApplied = json['saturday_rule_applied'] ?? '',
        calendarData = (json['calendar_data'] as List?)
            ?.map((e) => CalendarDayData.fromJson(e))
            .toList() ?? [];
}

class MemberInfo {
  final int memberId;
  final String empNo;
  final String name;
  final String designation;
  final String department;

  MemberInfo.fromJson(Map<String, dynamic> json)
      : memberId = json['member_id'] ?? 0,
        empNo = json['emp_no'] ?? '',
        name = json['name'] ?? '',
        designation = json['designation'] ?? '',
        department = json['department'] ?? '';
}

class CalendarDayData {
  final String date;
  final int dayNumber;
  final String dayType;
  final bool isHoliday;
  final String? holidayName;
  final bool isAbsentOrLeave;
  final String? leaveReason;
  final AttendanceDetails? attendanceDetails;

  CalendarDayData.fromJson(Map<String, dynamic> json)
      : date = json['date'] ?? '',
        dayNumber = json['day_number'] ?? 0,
        dayType = json['day_type'] ?? '',
        isHoliday = json['is_holiday'] ?? false,
        holidayName = json['holiday_name'],
        isAbsentOrLeave = json['is_absent_or_leave'] ?? false,
        leaveReason = json['leave_reason'],
        attendanceDetails = json['attendance_details'] != null 
            ? AttendanceDetails.fromJson(json['attendance_details'])
            : null;

  String get status {
    if (isHoliday) return 'holiday';
    if (isAbsentOrLeave) return 'absent';
    if (attendanceDetails?.status == 'PRESENT') return 'present';
    return 'absent';
  }
}

class AttendanceDetails {
  final int attendanceId;
  final String status;
  final String checkinTime;
  final String checkoutTime;
  final String workingHours;
  final String shift;
  final String otHours;
  final bool otApproved;

  AttendanceDetails.fromJson(Map<String, dynamic> json)
      : attendanceId = json['attendance_id'] ?? 0,
        status = json['status'] ?? '',
        checkinTime = json['checkin_time'] ?? '',
        checkoutTime = json['checkout_time'] ?? '',
        workingHours = json['working_hours'] ?? '',
        shift = json['shift'] ?? '',
        otHours = json['ot_hours'] ?? '',
        otApproved = json['ot_approved'] ?? false;
}