import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';

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
  static String get _baseUrl => '${dotenv.env['BASE_URL']}/api/maintainer/branches/';

  final StorageService _storageService = StorageService();

  // ── Form fields ──
  String branchName = '';
  String phone = '';
  SelectedLocation? selectedLocation;
  String punchInRadius = '';
  
  BranchModel? _existing;
  bool get isEdit => _existing != null;

  // ── State ──
  bool isLoading = false;
  Map<String, String?> errors = {};

  void init(BranchModel? existing) {
    _existing = existing;
    if (existing != null) {
      branchName = existing.name;
      phone = existing.phone;
      punchInRadius = existing.allowedRadiusMeter.toString();
      selectedLocation = SelectedLocation(
        address: existing.address,
        latitude: existing.latitude,
        longitude: existing.longitude,
      );
    } else {
      branchName = '';
      phone = '';
      punchInRadius = '';
      selectedLocation = null;
    }
  }

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
    
    final p = phone.trim();
    if (p.isEmpty) {
      errors['phone'] = 'Required';
    } else if (p.length < 10 || double.tryParse(p) == null) {
      errors['phone'] = 'Enter a valid phone number';
    }

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

      final String branchCode;
      if (isEdit) {
        branchCode = _existing!.branchCode;
      } else {
        branchCode = branchName
            .trim()
            .toUpperCase()
            .replaceAll(' ', '')
            .substring(0, branchName.trim().length.clamp(0, 3)) + '001';
      }

      final body = {
        'name': branchName.trim(),
        'branch_code': branchCode,
        'address': selectedLocation!.address,
        'phone': phone.trim(),
        'latitude': selectedLocation!.latitude,
        'longitude': selectedLocation!.longitude,
        'allowed_radius_meter': int.parse(punchInRadius.trim()),
      };

      debugPrint('${isEdit ? "Update" : "Create"} Branch Body: $body');

      final url = isEdit ? '$_baseUrl${_existing!.id}/' : _baseUrl;
      final uri = Uri.parse(url);
      
      final res = isEdit
          ? await http.patch(
              uri,
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
              body: jsonEncode(body),
            )
          : await http.post(
              uri,
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
        _showSnack(context, isEdit ? 'Branch updated successfully' : 'Branch created successfully', isError: false);
        if (context.mounted) Navigator.maybePop(context);
      } else {
        final json = jsonDecode(res.body);
        final message = json['message'] ?? json['detail'] ?? 'Failed to ${isEdit ? "update" : "create"} branch';
        _showSnack(context, message, isError: true);
      }
    } catch (e) {
      debugPrint('${isEdit ? "Update" : "Create"} Branch Error: $e');
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