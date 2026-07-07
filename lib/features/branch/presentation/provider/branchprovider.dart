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

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? nextPageUrl;
  int totalCount = 0;

  Future<void> fetchBranches({bool refresh = false}) async {
    if (refresh) {
      _all.clear();
      branches.clear();
      nextPageUrl = null;
      hasMore = true;
      totalCount = 0;
      isLoadingMore = false;
    }
    
    if (branches.isEmpty) {
      state = BranchLoadState.loading;
      notifyListeners();
    }
    
    isLoading = true;
    error = null;

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
        final Map<String, dynamic> data = jsonDecode(res.body);
        totalCount = data['count'] ?? 0;
        nextPageUrl = data['next'];
        hasMore = nextPageUrl != null;
        
        final List<dynamic> list = data['results'] ?? [];
        _all = list.map((e) => BranchModel.fromJson(e as Map<String, dynamic>)).toList();
        branches = List.from(_all);
        state = BranchLoadState.loaded;
      } else {
        error = 'Failed to load branches';
        state = BranchLoadState.error;
      }
    } catch (e) {
      error = 'Network error: $e';
      state = BranchLoadState.error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreBranches() async {
    if (isLoadingMore || !hasMore || nextPageUrl == null) return;

    isLoadingMore = true;
    notifyListeners();

    try {
      final token = await _storageService.getAccessToken();
      final res = await http.get(
        Uri.parse(nextPageUrl!),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(res.body);
        totalCount = data['count'] ?? 0;
        nextPageUrl = data['next'];
        hasMore = nextPageUrl != null;

        final List<dynamic> list = data['results'] ?? [];
        final newBranches = list.map((e) => BranchModel.fromJson(e as Map<String, dynamic>)).toList();
        
        _all.addAll(newBranches);
        branches.addAll(newBranches);
      }
    } catch (e) {
      debugPrint('Load more error: $e');
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshBranches() async {
    await fetchBranches(refresh: true);
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

  Future<bool> deleteBranch({required int id, required BuildContext context}) async {
    try {
      final token = await _storageService.getAccessToken();
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
        branches.removeWhere((d) => d.id == id);
        _all.removeWhere((d) => d.id == id);
        notifyListeners();
        _snack(context, 'Branch deleted', isError: false);
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

  void _snack(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? const Color(0xFFE53935)
            : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
