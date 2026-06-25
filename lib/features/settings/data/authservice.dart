import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class AuthService {
  static const String _baseUrl = 'https://offixo.archanastones.in/api/accounts';
  final StorageService _storageService = StorageService();

  /// Clears local session immediately, fires the logout API in the background.
  Future<void> logout() async {
    final refreshToken = await _storageService.getRefreshToken();
    final accessToken = await _storageService.getAccessToken();

    // Clear local data first — this is what actually matters for navigation
    await _storageService.clearAllData();

    // Fire-and-forget API call — don't block UI on this
    if (refreshToken != null) {
      _callLogoutApi(accessToken, refreshToken);
    }
  }

  void _callLogoutApi(String? accessToken, String refreshToken) {
    http.post(
      Uri.parse('$_baseUrl/maintainer/logout/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'refresh': refreshToken}),
    ).catchError((e) {
      debugPrint('Logout API error (ignored): $e');
    });
  }
}