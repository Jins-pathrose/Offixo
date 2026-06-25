import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class BranchOption {
  final int id;
  final String name;
  const BranchOption({required this.id, required this.name});

  factory BranchOption.fromJson(Map<String, dynamic> json) {
    return BranchOption(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

const List<Map<String, String>> saturdayRuleChoices = [
  {'id': 'ALL_OFF', 'name': 'All Saturdays Off'},
  {'id': 'ALL_WORKING', 'name': 'All Saturdays Working'},
  {'id': 'FIRST_OFF', 'name': 'First Saturday Off'},
  {'id': 'SECOND_OFF', 'name': 'Second Saturday Off'},
  {'id': 'THIRD_OFF', 'name': 'Third Saturday Off'},
  {'id': 'FOURTH_OFF', 'name': 'Fourth Saturday Off'},
  {'id': 'FIRST_THIRD_OFF', 'name': 'First & Third Saturday Off'},
  {'id': 'SECOND_FOURTH_OFF', 'name': 'Second & Fourth Saturday Off'},
];

class LeaveSettingsProvider extends ChangeNotifier {
  bool _isLoadingBranches = false;
  bool _isSubmitting = false;
  List<BranchOption> _branches = [];

  bool get isLoadingBranches => _isLoadingBranches;
  bool get isSubmitting => _isSubmitting;
  List<BranchOption> get branches => _branches;

  Future<void> fetchBranches() async {
    _isLoadingBranches = true;
    notifyListeners();

    try {
      final storageService = StorageService();
      final accessToken = await storageService.getAccessToken();

      final response = await http.get(
        Uri.parse(
            'https://offixo.archanastones.in/api/member/dropdown-choices/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['success'] == true) {
          final list = decoded['branches'] as List<dynamic>? ?? [];
          _branches = list
              .map((e) => BranchOption.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (_) {
      // leave _branches empty on failure
    }

    _isLoadingBranches = false;
    notifyListeners();
  }

  /// POST /api/leave/reset/  { "year": 2027 }
  Future<bool> resetAnnualLeave({
    required int year,
    required BuildContext context,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    bool success = false;
    try {
      final storageService = StorageService();
      final accessToken = await storageService.getAccessToken();

      final response = await http.post(
        Uri.parse('https://offixo.archanastones.in/api/leave/reset/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({'year': year}),
      );
      print(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        success = true;
        _showSnack(context, 'Leave balances reset for $year', isError: false);
      } else {
        final decoded = _safeDecode(response.body);
        _showSnack(
          context,
          decoded?['message']?.toString() ??
              'Failed to reset (${response.statusCode})',
          isError: true,
        );
      }
    } catch (e) {
      _showSnack(context, e.toString(), isError: true);
    }

    _isSubmitting = false;
    notifyListeners();
    return success;
  }

  /// POST /api/office-calendar/saturday-config/
  /// { "branch": 1, "saturday_rule": "SECOND_FOURTH_OFF" }
  Future<bool> saveSaturdayConfig({
    required int branchId,
    required String saturdayRule,
    required BuildContext context,
  }) async {
    _isSubmitting = true;
    notifyListeners();

    bool success = false;
    try {
      final storageService = StorageService();
      final accessToken = await storageService.getAccessToken();

      final response = await http.post(
        Uri.parse(
            'https://offixo.archanastones.in/api/office-calendar/saturday-config/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'branch': branchId,
          'saturday_rule': saturdayRule,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        success = true;
        _showSnack(context, 'Saturday rule updated', isError: false);
      } else {
        final decoded = _safeDecode(response.body);
        _showSnack(
          context,
          decoded?['message']?.toString() ??
              'Failed to save (${response.statusCode})',
          isError: true,
        );
      }
    } catch (e) {
      _showSnack(context, e.toString(), isError: true);
    }

    _isSubmitting = false;
    notifyListeners();
    return success;
  }

  Map<String, dynamic>? _safeDecode(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  void _showSnack(BuildContext context, String message,
      {required bool isError}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor:
          isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }
}