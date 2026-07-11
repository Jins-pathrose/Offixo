import 'package:flutter/material.dart';
import 'package:offixoadmin/features/designation/data/model/designationmodel.dart';
import 'package:offixoadmin/features/designation/data/repository/designation_repository.dart';

enum DeptLoadState { idle, loading, loaded, error }

class DesignationProvider extends ChangeNotifier {
  final DesignationRepository _repository = DesignationRepository();

  DeptLoadState state = DeptLoadState.idle;
  List<DesignationModel> designations = [];
  String? error;
  bool isSubmitting = false;

  bool isLoading = false;
  bool isLoadingMore = false;

  String? nextPageUrl;
  String? previousPageUrl;
  int totalCount = 0;
  int currentPage = 1;

  DesignationProvider() {
    fetchDesignations();
  }

  // ── Fetch ──
  Future<void> fetchDesignations({
    bool refresh = false,
    String? url,
    bool isNext = false,
    bool isPrev = false,
  }) async {
    if (refresh) {
      designations.clear();
      nextPageUrl = null;
      previousPageUrl = null;
      totalCount = 0;
      currentPage = 1;
      url = null;
    }

    if (designations.isEmpty && url == null) {
      state = DeptLoadState.loading;
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
      final data = await _repository.fetchDesignations(url);

      totalCount = data['count'] ?? 0;
      nextPageUrl = data['next'];
      previousPageUrl = data['previous'];

      final List<dynamic> list = data['results'] ?? [];
      designations = list
          .map((e) => DesignationModel.fromJson(e as Map<String, dynamic>))
          .toList();

      state = DeptLoadState.loaded;

      if (isNext) currentPage++;
      if (isPrev && currentPage > 1) currentPage--;

    } catch (e) {
      error = 'Network error: $e';
      state = DeptLoadState.error;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (nextPageUrl != null && !isLoadingMore) {
      await fetchDesignations(url: nextPageUrl, isNext: true);
    }
  }

  Future<void> loadPreviousPage() async {
    if (previousPageUrl != null && !isLoadingMore) {
      await fetchDesignations(url: previousPageUrl, isPrev: true);
    }
  }

  // ── Create ──
  Future<bool> create({
    required String name,
    required BuildContext context,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final success = await _repository.createDesignation(name);
      if (success) {
        await fetchDesignations(refresh: true);
        _snack(context, 'Designation created', isError: false);
        return true;
      } else {
        _snack(context, 'Failed to create', isError: true);
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
      final success = await _repository.updateDesignation(id, name);
      if (success) {
        await fetchDesignations(refresh: true);
        _snack(context, 'Designation updated', isError: false);
        return true;
      } else {
        _snack(context, 'Failed to update', isError: true);
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
  Future<bool> delete({required int id, required BuildContext context}) async {
    try {
      final success = await _repository.deleteDesignation(id);
      if (success) {
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
