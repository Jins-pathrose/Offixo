// lib/features/pending_requests/data/models/pending_request_model.dart

class PendingRequestModel {
  final int id;
  final String empNo;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String memberType;
  final String employeeStatus;
  final String approvalStatus;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? gender;
  final String? currentAddress;
  final String? permanentAddress;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? startDate;
  final String? createdAt;
  final String? updatedAt;
  final String? faceImage1;
  final String? faceImage2;
  final String? faceImage3;
  final String? faceImage4;

  PendingRequestModel({
    required this.id,
    required this.empNo,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.memberType,
    required this.employeeStatus,
    required this.approvalStatus,
    this.dateOfBirth,
    this.bloodGroup,
    this.gender,
    this.currentAddress,
    this.permanentAddress,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.startDate,
    this.createdAt,
    this.updatedAt,
    this.faceImage1,
    this.faceImage2,
    this.faceImage3,
    this.faceImage4,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory PendingRequestModel.fromJson(Map<String, dynamic> json) {
    return PendingRequestModel(
      id: json['id'],
      empNo: json['emp_no'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      memberType: json['member_type'] ?? '',
      employeeStatus: json['employee_status'] ?? '',
      approvalStatus: json['approval_status'] ?? 'PENDING',
      dateOfBirth: json['date_of_birth'],
      bloodGroup: json['blood_group'],
      gender: json['gender'],
      currentAddress: json['present_address'] ?? json['current_address'] ?? json['address'],
      permanentAddress: json['permanent_address'],
      emergencyContactName: json['emergency_contact_name'],
      emergencyContactPhone: json['emergency_contact_number'] ?? json['emergency_contact_phone'],
      startDate: json['start_date'] ?? json['date_of_joining'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      faceImage1: json['face_image_1'],
      faceImage2: json['face_image_2'],
      faceImage3: json['face_image_3'],
      faceImage4: json['face_image_4'],
    );
  }
}

class PendingRequestResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<PendingRequestModel> results;

  PendingRequestResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PendingRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return PendingRequestResponseModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List?)
              ?.map((e) => PendingRequestModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
