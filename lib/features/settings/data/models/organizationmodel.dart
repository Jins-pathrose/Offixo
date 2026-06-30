import 'package:flutter_dotenv/flutter_dotenv.dart';
class OrganizationModel {
  final int id;
  final String name;
  final String organizationType;
  final String organizationOwner;
  final String organizationAddress;
  final String organizationPhone;
 
  const OrganizationModel({
    required this.id,
    required this.name,
    required this.organizationType,
    required this.organizationOwner,
    required this.organizationAddress,
    required this.organizationPhone,
  });
 
  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      OrganizationModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        organizationType: json['organization_type'] ?? '',
        organizationOwner: json['organization_owner'] ?? '',
        organizationAddress: json['organization_address'] ?? '',
        organizationPhone: json['organization_phone'] ?? '',
      );
}
 
class MaintainerProfile {
  final int id;
  final String email;
  final String maintainerName;
  final String phone;
  final String address;
  final String? image;
  final OrganizationModel organization;
 
  String get imageUrl =>
      image != null && image!.isNotEmpty
          ? '${dotenv.env['BASE_URL']}$image'
          : '';
 
  const MaintainerProfile({
    required this.id,
    required this.email,
    required this.maintainerName,
    required this.phone,
    required this.address,
    this.image,
    required this.organization,
  });
 
  factory MaintainerProfile.fromJson(Map<String, dynamic> json) =>
      MaintainerProfile(
        id: json['id'] ?? 0,
        email: json['email'] ?? '',
        maintainerName: json['maintainer_name'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        image: json['image'],
        organization:
            OrganizationModel.fromJson(json['organization'] ?? {}),
      );
}