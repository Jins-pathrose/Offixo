class ShiftModel {
  final int id;
  final int organization;
  final String organizationName;
  final int? branch;
  final String shiftName;
  final String startTime; // "HH:mm:ss"
  final String endTime; // "HH:mm:ss"
  final int regularWorkingHours;
  final bool isActive;

  const ShiftModel({
    required this.id,
    required this.organization,
    required this.organizationName,
    this.branch,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.regularWorkingHours,
    required this.isActive,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      organization: json['organization'] is int ? json['organization'] as int : int.tryParse(json['organization']?.toString() ?? '0') ?? 0,
      organizationName: json['organization_name']?.toString() ?? '',
      branch: json['branch'] as int?,
      shiftName: json['shift_name']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      regularWorkingHours: num.tryParse(json['regular_working_hours']?.toString() ?? '0')?.toInt() ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 'true',
    );
  }

  /// Formats "10:00:00" -> "10:00 AM"
  String get startTimeDisplay => _formatTime(startTime);
  String get endTimeDisplay => _formatTime(endTime);

  static String _formatTime(String raw) {
    final parts = raw.split(':');
    if (parts.length < 2) return raw;
    int hour = int.tryParse(parts[0]) ?? 0;
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '${hour.toString().padLeft(2, '0')}:$minute $period';
  }
}