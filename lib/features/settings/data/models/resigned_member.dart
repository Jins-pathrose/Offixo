class ResignedMember {
  final int id;
  final String empNo;
  final String name;
  final String email;
  final String memberType;
  final String department;
  final String designation;
  final String phoneNumber;
  final String updatedAt;

  ResignedMember({
    required this.id,
    required this.empNo,
    required this.name,
    required this.email,
    required this.memberType,
    required this.department,
    required this.designation,
    required this.phoneNumber,
    required this.updatedAt,
  });

  factory ResignedMember.fromJson(Map<String, dynamic> json) {
    return ResignedMember(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      empNo: json['emp_no']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      memberType: json['member_type']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }
}
