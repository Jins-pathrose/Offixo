import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class BranchRepository {
  static String get _baseUrl =>
      '${dotenv.env['BASE_URL']}/api/maintainer/branches/';

  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> fetchBranches([String? url]) async {
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
      throw Exception('Failed to load branches: ${response.statusCode}');
    }
  }

  Future<bool> deleteBranch(int id) async {
    final token = await _storageService.getAccessToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl$id/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200 ||
        response.statusCode == 204 ||
        response.statusCode == 202) {
      return true;
    } else {
      throw Exception('Failed to delete branch: ${response.statusCode}');
    }
  }
}
