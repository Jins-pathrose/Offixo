import 'package:offixoadmin/features/addnewstaff/domain/addstaffmodel.dart';

class StaffListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<StaffListItemModel> results;

  StaffListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory StaffListResponse.fromJson(Map<String, dynamic> json) {
    return StaffListResponse(
      count: json['count'] ?? 0,
      next: json['next']?.toString(),
      previous: json['previous']?.toString(),
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => StaffListItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class StaffListItemModel {
  final int id;
  final String empNo;
  final String firstName;
  final String lastName;
  final String departmentName;
  final String designationName;
  final String? branch;
  final String? profileImage;

  StaffListItemModel({
    required this.id,
    required this.empNo,
    required this.firstName,
    required this.lastName,
    required this.departmentName,
    required this.designationName,
    this.branch,
    this.profileImage,
  });

  factory StaffListItemModel.fromJson(Map<String, dynamic> json) {
    return StaffListItemModel(
      id: json['id'] ?? 0,
      empNo: json['emp_no'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      departmentName: json['department_name'] ?? '',
      designationName: json['designation_name'] ?? '',
      branch: json['branch'] is Map
          ? (json['branch']['name'] ?? '').toString()
          : json['branch']?.toString(),
      profileImage: json['face_image_1'] is Map
          ? json['face_image_1']['url']?.toString()
          : json['face_image_1']?.toString(),
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  // Helper method to convert to MemberModel for AddSalaryScreen
  MemberModel toMemberModel() {
    return MemberModel(
      id: id,
      empNo: empNo,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
