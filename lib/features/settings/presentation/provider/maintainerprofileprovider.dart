import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/settings/data/models/organizationmodel.dart';
import 'package:offixoadmin/features/settings/domain/enumprofile.dart';

class MaintainerProfileProvider extends ChangeNotifier {
  static String get _baseUrl => '${dotenv.env['BASE_URL']}/api/accounts/maintainer/profile/';
 
  final StorageService _storageService = StorageService();
 
  MaintainerProfile? profile;
  ProfileLoadState state = ProfileLoadState.idle;
  String? error;
 
  MaintainerProfileProvider() {
    fetchProfile();
  }
 
  Future<void> fetchProfile() async {
    state = ProfileLoadState.loading;
    error = null;
    notifyListeners();
    try {
      final token = await _storageService.getAccessToken();
      final res = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        profile = MaintainerProfile.fromJson(json['maintainer']);
        state = ProfileLoadState.loaded;
      } else {
        error = 'Failed to load profile';
        state = ProfileLoadState.error;
      }
    } catch (e) {
      error = 'Network error: $e';
      state = ProfileLoadState.error;
    }
    notifyListeners();
  }
}