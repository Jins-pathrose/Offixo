// lib/features/staffs/data/repositories/staff_repository.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/staffs/data/staffmodel.dart';

class StaffRepository {
  static String get _baseUrl => '${dotenv.env['BASE_URL']}/api/member/create/';

  Future<List<StaffModel>> fetchStaffs() async {
    final token = await StorageService().getAccessToken(); // ← add await
  
  if (token == null || token.isEmpty) {
    print('No auth token found. Please login again.');
  }
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'];
      return results.map((e) => StaffModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load staff list');
    }
  }
}
