import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';
import 'package:offixoadmin/features/checkincheckouts/data/attendancemodel.dart';


enum AttendanceLoadState { idle, loading, loaded, error }

class AttendanceProvider extends ChangeNotifier {
  AttendanceLoadState _state = AttendanceLoadState.idle;
  List<AttendanceRecord> _records = [];
  List<BranchModel> _branches = [];
  BranchModel? _selectedBranch;
  String? _errorMessage;
  DateTime _selectedDate = DateTime.now();

  AttendanceLoadState get state => _state;
  List<AttendanceRecord> get records => _records;
  List<BranchModel> get branches => _branches;
  BranchModel? get selectedBranch => _selectedBranch;
  String? get errorMessage => _errorMessage;
  DateTime get selectedDate => _selectedDate;

  int get presentCount => _records.where((r) => r.isPresent).length;
  int get absentCount => _records.where((r) => r.isAbsent).length;
  int get lateCount => _records.where((r) => r.isLate).length;
  int get totalCount => _records.length;

  AttendanceProvider() {
    _init();
  }

  Future<void> _init() async {
    await _fetchBranches();
    await loadAttendance();
  }

  Future<void> _fetchBranches() async {
    try {
      final storageService = StorageService();
      final accessToken = await storageService.getAccessToken();

      final response = await http.get(
        Uri.parse(
            'https://offixo.archanastones.in/api/maintainer/branches/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          _branches = decoded
              .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
              .where((b) => b.isActive)
              .toList();
          // Auto-select first branch
          if (_branches.isNotEmpty) _selectedBranch = _branches.first;
        }
      }
    } catch (_) {
      // Branches are optional for filtering — silently ignore
    }
  }

  void selectBranch(BranchModel? branch) {
    _selectedBranch = branch;
    loadAttendance();
  }

  Future<void> setDate(DateTime date) async {
    _selectedDate = date;
    await loadAttendance();
  }

  Future<void> loadAttendance() async {
    _state = AttendanceLoadState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final storageService = StorageService();
      final accessToken = await storageService.getAccessToken();

      final dateStr =
          '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

      final queryParams = {
        'date': dateStr,
        if (_selectedBranch != null) 'branch_id': '${_selectedBranch!.id}',
      };

      final uri = Uri.parse(
              'https://offixo.archanastones.in/api/maintainer/date-wise-attendance/')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        if (decoded['success'] == true) {
          final data = decoded['data'] as List<dynamic>? ?? [];
          _records = data
              .map((e) =>
                  AttendanceRecord.fromJson(e as Map<String, dynamic>))
              .toList();
        } else {
          _records = [];
        }
        _state = AttendanceLoadState.loaded;
      } else {
        _errorMessage = 'Server error (${response.statusCode})';
        _state = AttendanceLoadState.error;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _state = AttendanceLoadState.error;
    }

    notifyListeners();
  }
}