// lib/features/login/presentation/providers/login_provider.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/login/data/loginmodel.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic> _permissions = {};

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic> get permissions => _permissions;

  LoginProvider() {
    loadPermissions();
  }

  Future<void> loadPermissions() async {
    final userData = await _storageService.getUserData();
    if (userData != null && userData['permissions'] != null) {
      _permissions = userData['permissions'] as Map<String, dynamic>;
      notifyListeners();
    }
  }

  bool hasPermission(String key) {
    if (_permissions.isEmpty) return false;
    return _permissions[key] == true;
  }

  void setEmail(String value) {
    notifyListeners();
  }

  void setPassword(String value) {
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/accounts/maintainer/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final loginResponse = LoginResponseModel.fromJson(responseData);

        // Store tokens and user data
        await _storageService.saveTokens(
          accessToken: loginResponse.accessToken,
          refreshToken: loginResponse.refreshToken,
          userData: responseData['maintainer'],
        );

        if (responseData['maintainer'] != null &&
            responseData['maintainer']['permissions'] != null) {
          _permissions =
              responseData['maintainer']['permissions'] as Map<String, dynamic>;
        }

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final error = jsonDecode(response.body);
        _errorMessage = error['message'] ?? 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
