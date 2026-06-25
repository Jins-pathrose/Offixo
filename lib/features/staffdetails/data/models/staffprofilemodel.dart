// ═══════════════════════════════════════════════
// ENUMS
// ═══════════════════════════════════════════════


// ═══════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════

import 'dart:ui';

class StaffProfile {
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

  // Computed getters for UI
  String get fullName => '$firstName $lastName';
  String get designationDept => '$designationName • $departmentName';
  String get branchDisplay => branch ?? 'Not Assigned';
  String? get profileImageUrl => faceImage1; // Use first face image as profile
  String get displayName => '$firstName $lastName';
  String get department => departmentName;
  String get designation => designationName;
  String get shift => currentShiftName;

  const StaffProfile({
    required this.id,
    required this.empNo,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.memberType,
    required this.departmentId,
    required this.departmentName,
    required this.designationId,
    required this.designationName,
    required this.currentShiftId,
    required this.currentShiftName,
    required this.phoneNumber,
    required this.bloodGroup,
    required this.gender,
    required this.dateOfBirth,
    this.branch,
    required this.presentAddress,
    required this.permanentAddress,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    this.proofDocument,
    required this.isBiometricEnabled,
    this.faceImage1,
    this.faceImage2,
    this.faceImage3,
    this.faceImage4,
    required this.allowManualEntry,
    required this.isActive,
    required this.organization,
    required this.startDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StaffProfile.fromJson(Map<String, dynamic> json) => StaffProfile(
        id: json['id'] ?? 0,
        empNo: json['emp_no'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        memberType: json['member_type'] ?? '',
        departmentId: json['department_id'] ?? 0,
        departmentName: json['department_name'] ?? '',
        designationId: json['designation_id'] ?? 0,
        designationName: json['designation_name'] ?? '',
        currentShiftId: json['current_shift_id'] ?? 0,
        currentShiftName: json['current_shift_name'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        bloodGroup: json['blood_group'] ?? '',
        gender: json['gender'] ?? '',
        dateOfBirth: json['date_of_birth'] ?? '',
        branch: json['branch'],
        presentAddress: json['present_address'] ?? '',
        permanentAddress: json['permanent_address'] ?? '',
        emergencyContactName: json['emergency_contact_name'] ?? '',
        emergencyContactPhone: json['emergency_contact_phone'] ?? '',
        proofDocument: json['proof_document'],
        isBiometricEnabled: json['is_biometric_enabled'] ?? false,
        faceImage1: json['face_image_1'],
        faceImage2: json['face_image_2'],
        faceImage3: json['face_image_3'],
        faceImage4: json['face_image_4'],
        allowManualEntry: json['allow_manual_entry'] ?? false,
        isActive: json['is_active'] ?? false,
        organization: Organization.fromJson(json['organization'] ?? {}),
        startDate: json['start_date'] ?? '',
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      );

  // Create a profile with default values for loading/error states
  factory StaffProfile.empty() => StaffProfile(
        id: 0,
        empNo: '',
        firstName: '--',
        lastName: '',
        email: '--',
        memberType: '--',
        departmentId: 0,
        departmentName: '--',
        designationId: 0,
        designationName: '--',
        currentShiftId: 0,
        currentShiftName: '--',
        phoneNumber: '--',
        bloodGroup: '--',
        gender: '--',
        dateOfBirth: '--',
        branch: '--',
        presentAddress: '--',
        permanentAddress: '--',
        emergencyContactName: '--',
        emergencyContactPhone: '--',
        proofDocument: null,
        isBiometricEnabled: false,
        faceImage1: null,
        faceImage2: null,
        faceImage3: null,
        faceImage4: null,
        allowManualEntry: false,
        isActive: false,
        organization: Organization.empty(),
        startDate: '--',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  // Mock data for development/testing
  factory StaffProfile.mock() => StaffProfile.fromJson({
        'id': 3,
        'emp_no': 'EMP0003',
        'first_name': 'Vismaya',
        'last_name': 'V',
        'email': 'anjali.techfifo@gmail.com',
        'member_type': 'FULL_TIME',
        'department_id': 1,
        'department_name': 'Human Resourcessss',
        'designation_id': 1,
        'designation_name': 'Python Django Developerrrr',
        'current_shift_id': 1,
        'current_shift_name': 'General Shiftt',
        'phone_number': '7994689053',
        'blood_group': 'O+',
        'gender': 'FEMALE',
        'date_of_birth': '1999-08-08',
        'branch': null,
        'present_address': 'Kochi, Keralaa',
        'permanent_address': 'Palakkad, Keralaa',
        'emergency_contact_name': 'Jaypal',
        'emergency_contact_phone': '7569841237',
        'proof_document': null,
        'is_biometric_enabled': false,
        'face_image_1': null,
        'face_image_2': null,
        'face_image_3': null,
        'face_image_4': null,
        'allow_manual_entry': false,
        'is_active': true,
        'organization': {
          'id': 1,
          'name': 'Techfifo Innovations',
          'organization_type': 'IT',
          'organization_owner': 'Nibi',
          'organization_address': 'Palakkad',
          'organization_phone': '9876543240'
        },
        'start_date': '2026-06-18',
        'created_at': '2026-06-22T14:29:10.823671+05:30',
        'updated_at': '2026-06-22T14:29:10.823671+05:30'
      });
}

class Organization {
  final int id;
  final String name;
  final String organizationType;
  final String organizationOwner;
  final String organizationAddress;
  final String organizationPhone;

  const Organization({
    required this.id,
    required this.name,
    required this.organizationType,
    required this.organizationOwner,
    required this.organizationAddress,
    required this.organizationPhone,
  });

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        organizationType: json['organization_type'] ?? '',
        organizationOwner: json['organization_owner'] ?? '',
        organizationAddress: json['organization_address'] ?? '',
        organizationPhone: json['organization_phone'] ?? '',
      );

  factory Organization.empty() => const Organization(
        id: 0,
        name: '--',
        organizationType: '--',
        organizationOwner: '--',
        organizationAddress: '--',
        organizationPhone: '--',
      );
}

// Helper extension for formatting
extension StaffProfileExtension on StaffProfile {
  String get formattedDateOfBirth {
    if (dateOfBirth.isEmpty) return '--';
    try {
      final parts = dateOfBirth.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return dateOfBirth;
    } catch (_) {
      return dateOfBirth;
    }
  }

  String get formattedStartDate {
    if (startDate.isEmpty) return '--';
    try {
      final parts = startDate.split('-');
      if (parts.length == 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return startDate;
    } catch (_) {
      return startDate;
    }
  }

  String get initials {
    final first = firstName.isNotEmpty ? firstName[0] : '';
    final last = lastName.isNotEmpty ? lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  String get displayGender {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return 'Male';
      case 'FEMALE':
        return 'Female';
      case 'OTHER':
        return 'Other';
      default:
        return gender;
    }
  }

  String get displayMemberType {
    switch (memberType.toUpperCase()) {
      case 'FULL_TIME':
        return 'Full Time';
      case 'PART_TIME':
        return 'Part Time';
      case 'CONTRACT':
        return 'Contract';
      case 'INTERN':
        return 'Intern';
      default:
        return memberType;
    }
  }

  String get displayStatus {
    return isActive ? 'Active' : 'Inactive';
  }

  Color get statusColor {
    return isActive ? const Color(0xFF22C55E) : const Color(0xFFE53935);
  }
}