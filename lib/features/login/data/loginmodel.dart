// lib/features/login/data/models/login_response_model.dart
class LoginResponseModel {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final MaintainerModel maintainer;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.maintainer,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['access'] ?? '',
      refreshToken: json['refresh'] ?? '',
      maintainer: MaintainerModel.fromJson(json['maintainer'] ?? {}),
    );
  }
}

class MaintainerModel {
  final int id;
  final String email;
  final String maintainerName;
  final String phone;
  final String address;
  final String? image;
  final OrganizationModel organization;
  final PermissionsModel permissions;

  MaintainerModel({
    required this.id,
    required this.email,
    required this.maintainerName,
    required this.phone,
    required this.address,
    required this.image,
    required this.organization,
    required this.permissions,
  });

  factory MaintainerModel.fromJson(Map<String, dynamic> json) {
    return MaintainerModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      maintainerName: json['maintainer_name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      image: json['image'],
      organization: OrganizationModel.fromJson(json['organization'] ?? {}),
      permissions: PermissionsModel.fromJson(json['permissions'] ?? {}),
    );
  }
}

class OrganizationModel {
  final int id;
  final String name;
  final String organizationType;
  final String organizationOwner;
  final String organizationAddress;
  final String organizationPhone;

  OrganizationModel({
    required this.id,
    required this.name,
    required this.organizationType,
    required this.organizationOwner,
    required this.organizationAddress,
    required this.organizationPhone,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      organizationType: json['organization_type'] ?? '',
      organizationOwner: json['organization_owner'] ?? '',
      organizationAddress: json['organization_address'] ?? '',
      organizationPhone: json['organization_phone'] ?? '',
    );
  }
}

class PermissionsModel {
  final bool canViewProfile;
  final bool canUpdateProfile;
  final bool canAddUser;
  final bool canViewUser;
  final bool canUpdateUser;
  final bool canDeleteUser;
  final bool canAddAttendance;
  final bool canViewAttendance;
  final bool canUpdateAttendance;
  final bool canDeleteAttendance;
  final bool canRegisterFace;
  final bool canVerifyFace;
  final bool canRegisterThumb;
  final bool canVerifyThumb;
  final bool canRegisterSelfie;
  final bool canVerifySelfie;
  final bool canViewOrganization;
  final bool canUpdateOrganization;
  final bool canViewDashboard;
  final bool canViewReports;
  final bool canSendNotification;
  final bool canManageSettings;

  PermissionsModel({
    required this.canViewProfile,
    required this.canUpdateProfile,
    required this.canAddUser,
    required this.canViewUser,
    required this.canUpdateUser,
    required this.canDeleteUser,
    required this.canAddAttendance,
    required this.canViewAttendance,
    required this.canUpdateAttendance,
    required this.canDeleteAttendance,
    required this.canRegisterFace,
    required this.canVerifyFace,
    required this.canRegisterThumb,
    required this.canVerifyThumb,
    required this.canRegisterSelfie,
    required this.canVerifySelfie,
    required this.canViewOrganization,
    required this.canUpdateOrganization,
    required this.canViewDashboard,
    required this.canViewReports,
    required this.canSendNotification,
    required this.canManageSettings,
  });

  factory PermissionsModel.fromJson(Map<String, dynamic> json) {
    return PermissionsModel(
      canViewProfile: json['can_view_profile'] ?? false,
      canUpdateProfile: json['can_update_profile'] ?? false,
      canAddUser: json['can_add_user'] ?? false,
      canViewUser: json['can_view_user'] ?? false,
      canUpdateUser: json['can_update_user'] ?? false,
      canDeleteUser: json['can_delete_user'] ?? false,
      canAddAttendance: json['can_add_attendance'] ?? false,
      canViewAttendance: json['can_view_attendance'] ?? false,
      canUpdateAttendance: json['can_update_attendance'] ?? false,
      canDeleteAttendance: json['can_delete_attendance'] ?? false,
      canRegisterFace: json['can_register_face'] ?? false,
      canVerifyFace: json['can_verify_face'] ?? false,
      canRegisterThumb: json['can_register_thumb'] ?? false,
      canVerifyThumb: json['can_verify_thumb'] ?? false,
      canRegisterSelfie: json['can_register_selfie'] ?? false,
      canVerifySelfie: json['can_verify_selfie'] ?? false,
      canViewOrganization: json['can_view_organization'] ?? false,
      canUpdateOrganization: json['can_update_organization'] ?? false,
      canViewDashboard: json['can_view_dashboard'] ?? false,
      canViewReports: json['can_view_reports'] ?? false,
      canSendNotification: json['can_send_notification'] ?? false,
      canManageSettings: json['can_manage_settings'] ?? false,
    );
  }
}