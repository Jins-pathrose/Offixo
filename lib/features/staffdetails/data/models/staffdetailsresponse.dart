import 'package:offixoadmin/features/staffdetails/data/models/staffprofilemodel.dart';

class StaffDetailsResponse {
  final int id;
  final String empNo;
  final String firstName;
  final String lastName;
  final String email;
  final String memberType;
  final int departmentId;
  final String departmentName;
  final int designationId;
  final String designationName;
  final int currentShiftId;
  final String currentShiftName;
  final String phoneNumber;
  final String bloodGroup;
  final String gender;
  final String dateOfBirth;
  final String? branch;
  final String presentAddress;
  final String permanentAddress;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String? proofDocument;
  final bool isBiometricEnabled;
  final String? faceImage1;
  final String? faceImage2;
  final String? faceImage3;
  final String? faceImage4;
  final bool allowManualEntry;
  final bool isActive;
  final Organization organization;
  final String startDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  StaffDetailsResponse.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      empNo = json['emp_no'] ?? '',
      firstName = json['first_name'] ?? '',
      lastName = json['last_name'] ?? '',
      email = json['email'] ?? '',
      memberType = json['member_type'] ?? '',
      departmentId = json['department_id'] ?? 0,
      departmentName = json['department_name'] ?? '',
      designationId = json['designation_id'] ?? 0,
      designationName = json['designation_name'] ?? '',
      currentShiftId = json['current_shift_id'] ?? 0,
      currentShiftName = json['current_shift_name'] ?? '',
      phoneNumber = json['phone_number'] ?? '',
      bloodGroup = json['blood_group'] ?? '',
      gender = json['gender'] ?? '',
      dateOfBirth = json['date_of_birth'] ?? '',
      // branch can be null, a String, or a Map object
      branch = json['branch'] is Map
          ? (json['branch']['name'] ?? '').toString()
          : json['branch']?.toString(),
      presentAddress = json['present_address'] ?? '',
      permanentAddress = json['permanent_address'] ?? '',
      emergencyContactName = json['emergency_contact_name'] ?? '',
      emergencyContactPhone = json['emergency_contact_phone'] ?? '',
      proofDocument = json['proof_document'] is Map
          ? json['proof_document']['url']?.toString()
          : json['proof_document']?.toString(),
      isBiometricEnabled = json['is_biometric_enabled'] ?? false,
      faceImage1 = json['face_image_1'] is Map
          ? json['face_image_1']['url']?.toString()
          : json['face_image_1']?.toString(),
      faceImage2 = json['face_image_2'] is Map
          ? json['face_image_2']['url']?.toString()
          : json['face_image_2']?.toString(),
      faceImage3 = json['face_image_3'] is Map
          ? json['face_image_3']['url']?.toString()
          : json['face_image_3']?.toString(),
      faceImage4 = json['face_image_4'] is Map
          ? json['face_image_4']['url']?.toString()
          : json['face_image_4']?.toString(),
      allowManualEntry = json['allow_manual_entry'] ?? false,
      isActive = json['is_active'] ?? false,
      organization = Organization.fromJson(
          json['organization'] is Map
              ? json['organization'] as Map<String, dynamic>
              : {}),
      startDate = json['start_date'] ?? '',
      createdAt = DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt = DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now();

  String get fullName => '$firstName $lastName';
  String get designationDept => '$designationName • $departmentName';
}
