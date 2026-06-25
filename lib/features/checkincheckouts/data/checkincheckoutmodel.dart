class BranchModel {
  final int id;
  final String name;
  final String branchCode;
  final bool isActive;

  const BranchModel({
    required this.id,
    required this.name,
    required this.branchCode,
    required this.isActive,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] as int,
      name: json['name'] as String,
      branchCode: json['branch_code'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}