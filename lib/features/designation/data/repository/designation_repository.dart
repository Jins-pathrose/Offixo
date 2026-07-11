import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class DesignationRepository {
  static String get _baseUrl =>
      '${dotenv.env['BASE_URL']}/api/maintainer/designations/';

  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> fetchDesignations([String? url]) async {
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
      throw Exception('Failed to load designations: ${response.statusCode}');
    }
  }

  Future<bool> createDesignation(String name) async {
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

  Future<bool> updateDesignation(int id, String name) async {
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

  Future<bool> deleteDesignation(int id) async {
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
