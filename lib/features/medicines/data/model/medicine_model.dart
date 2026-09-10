class MedicineModel {
  final int id;
  final int organization;
  final String name;
  final String code;
  final String description;
  final bool isActive;
  final String createdAt;

  const MedicineModel({
    required this.id,
    required this.organization,
    required this.name,
    required this.code,
    required this.description,
    required this.isActive,
    required this.createdAt,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) => MedicineModel(
        id: json['id'] ?? 0,
        organization: json['organization'] ?? 0,
        name: json['name'] ?? '',
        code: json['code'] ?? '',
        description: json['description'] ?? '',
        isActive: json['is_active'] ?? true,
        createdAt: json['created_at'] ?? '',
      );
}
