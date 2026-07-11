import 'package:flutter/material.dart';
import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';
import 'package:offixoadmin/features/branch/data/repository/branch_repository.dart';

enum BranchLoadState { idle, loading, loaded, error }

class BranchProvider extends ChangeNotifier {
  final BranchRepository _repository = BranchRepository();

  List<BranchModel> _all = [];
  List<BranchModel> branches = [];
  BranchLoadState state = BranchLoadState.idle;
  String? error;

  bool isLoading = false;
  bool isLoadingMore = false;
  
  String? nextPageUrl;
  String? previousPageUrl;
  int totalCount = 0;
  int currentPage = 1;

  Future<void> fetchBranches({
    bool refresh = false,
    String? url,
    bool isNext = false,
    bool isPrev = false,
  }) async {
    if (refresh) {
      _all.clear();
      branches.clear();
      nextPageUrl = null;
      previousPageUrl = null;
      totalCount = 0;
      currentPage = 1;
      url = null;
    }

    if (branches.isEmpty && url == null) {
      state = BranchLoadState.loading;
      notifyListeners();
    } else if (url != null) {
      isLoadingMore = true;
      notifyListeners();
    }

    if (url == null) {
      isLoading = true;
    }
    
    error = null;

    try {
      final data = await _repository.fetchBranches(url);
      
      totalCount = data['count'] ?? 0;
      nextPageUrl = data['next'];
      previousPageUrl = data['previous'];

      final List<dynamic> list = data['results'] ?? [];
      _all = list
          .map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
          .toList();
      branches = List.from(_all);
      state = BranchLoadState.loaded;

      if (isNext) currentPage++;
      if (isPrev && currentPage > 1) currentPage--;

    } catch (e) {
      error = 'Network error: $e';
      state = BranchLoadState.error;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (nextPageUrl != null && !isLoadingMore) {
      await fetchBranches(url: nextPageUrl, isNext: true);
    }
  }

  Future<void> loadPreviousPage() async {
    if (previousPageUrl != null && !isLoadingMore) {
      await fetchBranches(url: previousPageUrl, isPrev: true);
    }
  }

  Future<void> refreshBranches() async {
    await fetchBranches(refresh: true);
  }

  void search(String query) {
    final q = query.toLowerCase().trim();
    branches = q.isEmpty
        ? List.from(_all)
        : _all.where(
            (b) =>
                b.name.toLowerCase().contains(q) ||
                b.address.toLowerCase().contains(q) ||
                b.branchCode.toLowerCase().contains(q),
          ).toList();
    notifyListeners();
  }

  Future<bool> deleteBranch({
    required int id,
    required BuildContext context,
  }) async {
    try {
      final success = await _repository.deleteBranch(id);
      if (success) {
        branches.removeWhere((d) => d.id == id);
        _all.removeWhere((d) => d.id == id);
        notifyListeners();
        _snack(context, 'Branch deleted', isError: false);
        return true;
      }
      return false;
    } catch (_) {
      _snack(context, 'Failed to delete', isError: true);
      return false;
    }
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
