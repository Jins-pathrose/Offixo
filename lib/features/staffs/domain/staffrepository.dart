// lib/features/staffs/data/repositories/staff_repository.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
}
