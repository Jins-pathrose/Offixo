import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';

enum BranchLoadState { idle, loading, loaded, error }

class BranchProvider extends ChangeNotifier {
  static String get _baseUrl => '${dotenv.env['BASE_URL']}/api/maintainer/branches/';

  final StorageService _storageService = StorageService();

  List<BranchModel> _all = [];
  List<BranchModel> branches = [];
  BranchLoadState state = BranchLoadState.idle;
  String? error;

  Future<void> loadBranches() async {
    state = BranchLoadState.loading;
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
      print(res.statusCode);
      print(res.body);
      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);

        final List<dynamic> list = data['results'];

        _all =
            list
                .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
                .toList();

        branches = List.from(_all);

        state = BranchLoadState.loaded;
      } else {
        error = 'Failed to load branches';
        state = BranchLoadState.error;
      }
    } catch (e) {
      error = 'Network error: $e';
      state = BranchLoadState.error;
    }
    notifyListeners();
  }

  void search(String query) {
    final q = query.toLowerCase().trim();
    branches =
        q.isEmpty
            ? List.from(_all)
            : _all
                .where(
                  (b) =>
                      b.name.toLowerCase().contains(q) ||
                      b.address.toLowerCase().contains(q) ||
                      b.branchCode.toLowerCase().contains(q),
                )
                .toList();
    notifyListeners();
  }
}
