// lib/features/pending_requests/domain/pending_request_repository.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/pending_requests/data/models/pending_request_model.dart';

class PendingRequestRepository {
  static String get _baseUrl =>
      '${dotenv.env['BASE_URL']}/api/maintainer_duty/members/pending/';

  Future<PendingRequestResponseModel> fetchPendingRequests({
    String? url,
    String? status,
  }) async {
    final token = await StorageService().getAccessToken();
    String targetUrl = url ?? _baseUrl;

    if (url == null && status != null) {
      targetUrl = '$targetUrl?status=$status';
    }

    final response = await http.get(
      Uri.parse(targetUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PendingRequestResponseModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load pending requests: ${response.statusCode}',
      );
    }
  }

  Future<PendingRequestModel> fetchPendingRequestDetails(int id) async {
    final token = await StorageService().getAccessToken();
    final url =
        '${dotenv.env['BASE_URL']}/api/maintainer_duty/members/pending/$id/';

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    print(response.statusCode);
    print(response.body);
    print("pending request details");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PendingRequestModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to load pending request details: ${response.statusCode}',
      );
    }
  }

  Future<bool> performAction(int id, String action) async {
    final token = await StorageService().getAccessToken();
    final url =
        '${dotenv.env['BASE_URL']}/api/maintainer_duty/members/$id/action/';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"action": action}),
    );

    print(response.statusCode);
    print(response.body);
    print("action taken");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      String errorMsg = 'Failed to perform action: ${response.statusCode}';
      try {
        final data = jsonDecode(response.body);
        if (data is Map) {
          if (data.containsKey('error')) {
            errorMsg = data['error'];
          } else if (data.containsKey('detail')) {
            errorMsg = data['detail'];
          } else if (data.containsKey('message')) {
            errorMsg = data['message'];
          }
        }
      } catch (_) {}
      throw Exception(errorMsg);
    }
  }
}
