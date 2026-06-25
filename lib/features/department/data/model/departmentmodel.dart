class DepartmentModel {
  final int id;
  final String name;
  final bool isActive;
  final String createdAt;

  const DepartmentModel({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) =>
      DepartmentModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        isActive: json['is_active'] ?? true,
        createdAt: json['created_at'] ?? '',
      );
}