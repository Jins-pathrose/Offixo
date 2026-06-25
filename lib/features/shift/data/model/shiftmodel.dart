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
      id: json['id'] as int,
      organization: json['organization'] as int,
      organizationName: json['organization_name'] as String? ?? '',
      branch: json['branch'] as int?,
      shiftName: json['shift_name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      regularWorkingHours: json['regular_working_hours'] as int,
      isActive: json['is_active'] as bool? ?? true,
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