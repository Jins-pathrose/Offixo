import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class DepartmentRepository {
  static String get _baseUrl =>
      '${dotenv.env['BASE_URL']}/api/maintainer/departments/';

  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> fetchDepartments([String? url]) async {
    final targetUrl = url ?? _baseUrl;
    final token = await _storageService.getAccessToken();

    final response = await http.get(
      Uri.parse(targetUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load departments: ${response.statusCode}');
    }
  }

  Future<bool> createDepartment(String name) async {
    final token = await _storageService.getAccessToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name.trim()}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateDepartment(int id, String name) async {
    final token = await _storageService.getAccessToken();
    final response = await http.patch(
      Uri.parse('$_baseUrl$id/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'name': name.trim()}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteDepartment(int id) async {
    final token = await _storageService.getAccessToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    return response.statusCode == 200 ||
        response.statusCode == 204 ||
        response.statusCode == 202;
  }
}
