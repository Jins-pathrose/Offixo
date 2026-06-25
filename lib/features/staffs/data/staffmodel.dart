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