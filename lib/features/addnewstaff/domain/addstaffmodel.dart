class MemberModel {
  final int id;
  final String empNo;
  final String firstName;
  final String lastName;

  const MemberModel({
    required this.id,
    required this.empNo,
    required this.firstName,
    required this.lastName,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as int,
      empNo: json['emp_no'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
    );
  }

  String get fullName => '$firstName $lastName'.trim();
}

class AddStaffResponse {
  final bool success;
  final String? message;
  final MemberModel? member;

  const AddStaffResponse({
    required this.success,
    this.message,
    this.member,
  });

  factory AddStaffResponse.fromJson(Map<String, dynamic> json) {
    return AddStaffResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      member: json['member'] != null
          ? MemberModel.fromJson(json['member'] as Map<String, dynamic>)
          : null,
    );
  }
}