import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

// ─────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────

class SelectedLocation {
  final String address;
  final double latitude;
  final double longitude;

  const SelectedLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

// ─────────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────────

class CreateBranchProvider extends ChangeNotifier {
  static const String _baseUrl =
      'https://offixo.archanastones.in/api/maintainer/branches/';

  final StorageService _storageService = StorageService();

  // ── Form fields ──
  String branchName = '';
  SelectedLocation? selectedLocation;
  String punchInRadius = '';

  // ── State ──
  bool isLoading = false;
  Map<String, String?> errors = {};

  // ── Set location (called from map screen) ──
  void setLocation(SelectedLocation location) {
    selectedLocation = location;
    errors.remove('location');
    notifyListeners();
  }

  // ── Validation ──
  bool _validate() {
    errors = {};
    if (branchName.trim().isEmpty) errors['branchName'] = 'Required';
    if (selectedLocation == null) errors['location'] = 'Please choose a location';
    if (punchInRadius.trim().isEmpty) {
      errors['punchInRadius'] = 'Required';
    } else if (int.tryParse(punchInRadius.trim()) == null) {
      errors['punchInRadius'] = 'Enter a valid number';
    }
    notifyListeners();
    return errors.isEmpty;
  }

  // ── Submit ──
  Future<void> submit(BuildContext context) async {
    if (!_validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      final token = await _storageService.getAccessToken();

      // Auto-generate a branch code from name
      final branchCode = branchName
          .trim()
          .toUpperCase()
          .replaceAll(' ', '')
          .substring(0, branchName.trim().length.clamp(0, 3));

      final body = {
        'name': branchName.trim(),
        'branch_code': '${branchCode}001',
        'address': selectedLocation!.address,
        'phone': '',
        'latitude': selectedLocation!.latitude,
        'longitude': selectedLocation!.longitude,
        'allowed_radius_meter': int.parse(punchInRadius.trim()),
      };

      debugPrint('Create Branch Body: $body');

      final res = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Status: ${res.statusCode}');
      debugPrint('Response: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        _showSnack(context, 'Branch created successfully', isError: false);
        if (context.mounted) Navigator.maybePop(context);
      } else {
        final json = jsonDecode(res.body);
        final message = json['message'] ?? json['detail'] ?? 'Failed to create branch';
        _showSnack(context, message, isError: true);
      }
    } catch (e) {
      debugPrint('Create Branch Error: $e');
      _showSnack(context, 'Something went wrong: $e', isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showSnack(BuildContext context, String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}