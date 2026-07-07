// lib/features/staffs/data/models/staff_model.dart

class StaffModel {
  final int id;
  final String empNo;
  final String firstName;
  final String lastName;
  final String designation;
  final String phoneNumber;
  final String email;
  final bool isActive;
  final String? faceImage;

  StaffModel({
    required this.id,
    required this.empNo,
    required this.firstName,
    required this.lastName,
    required this.designation,
    required this.phoneNumber,
    required this.email,
    required this.isActive,
    this.faceImage,
  });

  String get fullName => '$firstName $lastName';

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      id: json['id'],
      empNo: json['emp_no'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      designation: json['designation'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? false,
      faceImage: json['face_image_1'],
    );
  }
}

class StaffResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<StaffModel> results;

  StaffResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory StaffResponseModel.fromJson(Map<String, dynamic> json) {
    return StaffResponseModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List?)
              ?.map((e) => StaffModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}