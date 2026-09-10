import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class MedicineRepository {
  static String get _baseUrl =>
      '${dotenv.env['BASE_URL']}/api/medicalrep/add-medicines/';

  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> fetchMedicines([String? url]) async {
    final targetUrl = url ?? _baseUrl;
    final token = await _storageService.getAccessToken();

    final response = await http.get(
      Uri.parse(targetUrl),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load medicines: ${response.statusCode}');
    }
  }

  Future<bool> createMedicine(
    String name,
    String code,
    String description,
    bool isActive,
  ) async {
    final token = await _storageService.getAccessToken();
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name.trim(),
        'code': code.trim(),
        'description': description.trim(),
        'is_active': isActive,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> updateMedicine(
    int id,
    String name,
    String code,
    String description,
    bool isActive,
  ) async {
    final token = await _storageService.getAccessToken();
    final response = await http.patch(
      Uri.parse('$_baseUrl$id/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name.trim(),
        'code': code.trim(),
        'description': description.trim(),
        'is_active': isActive,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> deleteMedicine(int id) async {
    final token = await _storageService.getAccessToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    return response.statusCode == 200 ||
        response.statusCode == 204 ||
        response.statusCode == 202;
  }

  Future<Map<String, dynamic>> fetchSelectedMedicines(int attendanceId) async {
    final token = await _storageService.getAccessToken();
    final String url =
        '${dotenv.env['BASE_URL']}/api/medicalrep/maintainer/$attendanceId/selected-medicines/';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    print('url : $url');
    print('Testing medical rep');
    print('response : ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to load selected medicines: ${response.statusCode}',
      );
    }
  }
}
