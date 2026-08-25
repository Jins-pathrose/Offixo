// lib/features/staffs/data/repositories/staff_repository.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/staffs/data/staffmodel.dart';

class StaffRepository {
  static String get _baseUrl => '${dotenv.env['BASE_URL']}/api/member/create/';

  Future<StaffResponseModel> fetchStaffs({String? url}) async {
    final token = await StorageService().getAccessToken(); // ← add await

    if (token == null || token.isEmpty) {
      print('No auth token found. Please login again.');
    }

    final targetUrl = url ?? _baseUrl;

    final response = await http.get(
      Uri.parse(targetUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    print(response.body);
    print("ankara messssiiiii");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return StaffResponseModel.fromJson(data);
    } else {
      throw Exception('Failed to load staff list');
    }
  }

  Future<bool> checkInStaff(int memberId) async {
    final token = await StorageService().getAccessToken();
    final url = '${dotenv.env['BASE_URL']}/api/maintainer_duty/manual-checkin/';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"member_id": memberId}),
    );
    print(response.statusCode);
    print(response.body);
    print("checkinnnn");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to check in: ${response.body}');
    }
  }

  Future<bool> checkOutStaff(int memberId) async {
    final token = await StorageService().getAccessToken();
    final url =
        '${dotenv.env['BASE_URL']}/api/maintainer_duty/manual-checkout/';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"member_id": memberId}),
    );
    print(response.statusCode);
    print(response.body);
    print("checkoutt");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to check out: ${response.body}');
    }
  }
}
