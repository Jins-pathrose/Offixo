import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/designation/data/model/designationmodel.dart';

enum DeptLoadState { idle, loading, loaded, error }

class DesignationProvider extends ChangeNotifier {
  static const String _baseUrl =
      'https://offixo.archanastones.in/api/maintainer/designations/';

  final StorageService _storage = StorageService();

  DeptLoadState state = DeptLoadState.idle;
  List<DesignationModel> designations = [];
  String? error;
  bool isSubmitting = false;

  DesignationProvider() {
    fetchDesignations();
  }

  // ── Fetch ──
  Future<void> fetchDesignations() async {
    state = DeptLoadState.loading;
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
        final list = jsonDecode(res.body) as List;
        designations =
            list.map((e) => DesignationModel.fromJson(e)).toList();
        state = DeptLoadState.loaded;
      } else {
        error = 'Failed to load designations';
        state = DeptLoadState.error;
      }
    } catch (e) {
      error = 'Network error: $e';
      state = DeptLoadState.error;
    }
    notifyListeners();
  }

  // ── Create ──
  Future<bool> create({
    required String name,
    required BuildContext context,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final token = await _storage.getAccessToken();
      final res = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name.trim()}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchDesignations();
        _snack(context, 'Designation created', isError: false);
        return true;
      } else {
        _snack(context, _extractError(res.body), isError: true);
        return false;
      }
    } catch (_) {
      _snack(context, 'Please try again later', isError: true);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ── Update (PATCH) ──
  Future<bool> update({
    required int id,
    required String name,
    required BuildContext context,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final token = await _storage.getAccessToken();
      final res = await http.patch(
        Uri.parse('$_baseUrl$id/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name.trim()}),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchDesignations();
        _snack(context, 'Designation updated', isError: false);
        return true;
      } else {
        _snack(context, _extractError(res.body), isError: true);
        return false;
      }
    } catch (_) {
      _snack(context, 'Please try again later', isError: true);
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  // ── Delete ──
  Future<bool> delete({
    required int id,
    required BuildContext context,
  }) async {
    try {
      final token = await _storage.getAccessToken();
      final res = await http.delete(
        Uri.parse('$_baseUrl$id/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200 ||
          res.statusCode == 204 ||
          res.statusCode == 202) {
        designations.removeWhere((d) => d.id == id);
        notifyListeners();
        _snack(context, 'Designation deleted', isError: false);
        return true;
      } else {
        _snack(context, 'Failed to delete', isError: true);
        return false;
      }
    } catch (_) {
      _snack(context, 'Please try again later', isError: true);
      return false;
    }
  }

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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }
}