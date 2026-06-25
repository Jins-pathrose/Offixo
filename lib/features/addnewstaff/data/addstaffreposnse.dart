import 'package:offixoadmin/features/addnewstaff/domain/addstaffmodel.dart';

class AddStaffResponse {
  final bool success;
  final String message;
  final MemberModel? member;
 
  AddStaffResponse({
    required this.success,
    required this.message,
    this.member,
  });
 
  factory AddStaffResponse.fromJson(Map<String, dynamic> json) {
    return AddStaffResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      member:
          json['member'] != null ? MemberModel.fromJson(json['member']) : null,
    );
  }
}