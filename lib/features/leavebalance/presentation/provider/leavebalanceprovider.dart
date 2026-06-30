import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/leavebalance/data/models/leavebalancemodel.dart';

enum BalanceLoadState { idle, loading, loaded, error }

class LeaveBalanceProvider extends ChangeNotifier {
  static String get _baseUrl => '${dotenv.env['BASE_URL']}/api/leave/maintainer/balances/';

  BalanceLoadState _state = BalanceLoadState.idle;
  List<EmployeeLeaveBalance> _all = [];
  List<EmployeeLeaveBalance> _filtered = [];
  String? _errorMessage;
  int? year;

  BalanceLoadState get state => _state;
  List<EmployeeLeaveBalance> get employees => _filtered;
  String? get errorMessage => _errorMessage;

  LeaveBalanceProvider() {
    loadBalances();
  }

  Future<void> loadBalances() async {
    _state = BalanceLoadState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final storageService = StorageService();
      final accessToken = await storageService.getAccessToken();

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          year = decoded['year'] as int?;
          final data = decoded['data'];
          if (data is List) {
            _all = data
                .map((e) => EmployeeLeaveBalance.fromJson(
                    e as Map<String, dynamic>))
                .toList();
          } else {
            _all = [];
          }
        } else {
          _all = [];
        }

        _filtered = List.from(_all);
        _state = BalanceLoadState.loaded;
      } else {
        _errorMessage = 'Server error (${response.statusCode})';
        _state = BalanceLoadState.error;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = BalanceLoadState.error;
    }

    notifyListeners();
  }

  // ── Search ──
  void search(String query) {
    final q = query.toLowerCase().trim();
    _filtered = q.isEmpty
        ? List.from(_all)
        : _all
            .where((e) =>
                e.fullName.toLowerCase().contains(q) ||
                e.empNo.toLowerCase().contains(q) ||
                e.branchName.toLowerCase().contains(q) ||
                e.designation.toLowerCase().contains(q))
            .toList();
    notifyListeners();
  }
}