class LeaveTypeModel {
  final int id;
  final String name;
  final String code;
  final int totalDaysPerYear;
  final bool isRestrictedHoliday;
  final bool isActive;
  final String createdAt;

  const LeaveTypeModel({
    required this.id,
    required this.name,
    required this.code,
    required this.totalDaysPerYear,
    required this.isRestrictedHoliday,
    required this.isActive,
    required this.createdAt,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) => LeaveTypeModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        code: json['code'] ?? '',
        totalDaysPerYear: json['total_days_per_year'] ?? 0,
        isRestrictedHoliday: json['is_restricted_holiday'] ?? false,
        isActive: json['is_active'] ?? false,
        createdAt: json['created_at'] ?? '',
      );
}