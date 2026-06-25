class DesignationModel {
  final int id;
  final String name;
  final bool isActive;
  final String createdAt;

  const DesignationModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
  });

  factory DesignationModel.fromJson(Map<String, dynamic> json) =>
      DesignationModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        isActive: json['is_active'] ?? true,
        createdAt: json['created_at'] ?? '',
      );
}