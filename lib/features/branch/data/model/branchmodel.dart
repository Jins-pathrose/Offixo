class BranchModel {
  final int id;
  final String name;
  final String branchCode;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final int allowedRadiusMeter;
  final bool isActive;
  final String createdAt;

  const BranchModel({
    required this.id,
    required this.name,
    required this.branchCode,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.allowedRadiusMeter,
    required this.isActive,
    required this.createdAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
        id: json['id'],
        name: json['name'] ?? '',
        branchCode: json['branch_code'] ?? '',
        address: json['address'] ?? '',
        phone: json['phone'] ?? '',
        latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
        longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
        allowedRadiusMeter: json['allowed_radius_meter'] ?? 0,
        isActive: json['is_active'] ?? false,
        createdAt: json['created_at'] ?? '',
      );

  String get formattedDate {
    try {
      final dt = DateTime.parse(createdAt);
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}';
    } catch (_) {
      return '--';
    }
  }
}