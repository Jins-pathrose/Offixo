import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/leavetype/data/model/leavetypemodel.dart';

enum LeaveTypeLoadState { idle, loading, loaded, error }

class LeaveTypeProvider extends ChangeNotifier {
  static String get _baseUrl => '${dotenv.env['BASE_URL']}/api/leave/type/';

  final StorageService _storage = StorageService();

  LeaveTypeLoadState state = LeaveTypeLoadState.idle;
  List<LeaveTypeModel> leaveTypes = [];
  String? error;
  bool isSubmitting = false;

  LeaveTypeProvider() {
    fetchLeaveTypes();
  }

  // ── Fetch ──
  Future<void> fetchLeaveTypes() async {
    state = LeaveTypeLoadState.loading;
    error = null;
    notifyListeners();
    try {
      final token = await _storage.getAccessToken();
      final res = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);

        final List<dynamic> list = data['results'];

        leaveTypes =
            list
                .map((e) => LeaveTypeModel.fromJson(e as Map<String, dynamic>))
                .toList();

        state = LeaveTypeLoadState.loaded;
      } else {
        error = 'Failed to load leave types';
        state = LeaveTypeLoadState.error;
      }
    } catch (e) {
      error = 'Network error: $e';
      state = LeaveTypeLoadState.error;
    }
    notifyListeners();
  }

  // ── Create ──
  Future<bool> create({
    required String name,
    required String code,
    required int totalDays,
    required bool isRestricted,
    required BuildContext context,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final token = await _storage.getAccessToken();
      final body = <String, dynamic>{
        'name': name.trim(),
        'code': code.trim().toUpperCase(),
        'total_days_per_year': totalDays,
      };
      if (isRestricted) body['is_restricted_holiday'] = true;

      final res = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Create leave type: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchLeaveTypes();
        _snack(context, 'Leave type created', isError: false);
        return true;
      } else {
        final msg = _extractError(res.body);
        _snack(context, msg, isError: true);
        return false;
      }
    } catch (e) {
      _snack(context, 'Please try again later', isError: true);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ── Update ──
  Future<bool> update({
    required int id,
    required String name,
    required String code,
    required int totalDays,
    required bool isRestricted,
    required BuildContext context,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final token = await _storage.getAccessToken();
      final body = <String, dynamic>{
        'name': name.trim(),
        'code': code.trim().toUpperCase(),
        'total_days_per_year': totalDays,
        'is_restricted_holiday': isRestricted,
      };

      final res = await http.put(
        Uri.parse('${dotenv.env['BASE_URL']}/api/leave/type/update/$id/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Update leave type: ${res.statusCode} ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchLeaveTypes();
        _snack(context, 'Leave type updated', isError: false);
        return true;
      } else {
        _snack(context, _extractError(res.body), isError: true);
        return false;
      }
    } catch (e) {
      _snack(context, 'Please try again later', isError: true);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ── Delete ──
  Future<bool> delete({required int id, required BuildContext context}) async {
    try {
      final token = await _storage.getAccessToken();
      final res = await http.delete(
        Uri.parse('${dotenv.env['BASE_URL']}/api/leave/type/delete/$id/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Delete leave type: ${res.statusCode}');
      print(res.body);
      if (res.statusCode == 200 ||
          res.statusCode == 204 ||
          res.statusCode == 202) {
        leaveTypes.removeWhere((l) => l.id == id);
        notifyListeners();
        _snack(context, 'Leave type deleted', isError: false);
        return true;
      } else {
        _snack(context, 'Failed to delete', isError: true);
        return false;
      }
    } catch (e) {
      _snack(context, 'Please try again later', isError: true);
      return false;
    }
  }

  // ── Helpers ──
  String _extractError(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map) {
        final first = json.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
        return first.toString();
      }
    } catch (_) {}
    return 'Please try again later';
  }

  void _snack(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
