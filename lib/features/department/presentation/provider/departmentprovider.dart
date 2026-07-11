import 'package:flutter/material.dart';
import 'package:offixoadmin/features/department/data/model/departmentmodel.dart';
import 'package:offixoadmin/features/department/data/repository/department_repository.dart';

enum DeptLoadState { idle, loading, loaded, error }

class DepartmentProvider extends ChangeNotifier {
  final DepartmentRepository _repository = DepartmentRepository();

  DeptLoadState state = DeptLoadState.idle;
  List<DepartmentModel> departments = [];
  String? error;
  bool isSubmitting = false;

  bool isLoading = false;
  bool isLoadingMore = false;

  String? nextPageUrl;
  String? previousPageUrl;
  int totalCount = 0;
  int currentPage = 1;

  DepartmentProvider() {
    fetchDepartments();
  }

  // ── Fetch ──
  Future<void> fetchDepartments({
    bool refresh = false,
    String? url,
    bool isNext = false,
    bool isPrev = false,
  }) async {
    if (refresh) {
      departments.clear();
      nextPageUrl = null;
      previousPageUrl = null;
      totalCount = 0;
      currentPage = 1;
      url = null;
    }

    if (departments.isEmpty && url == null) {
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
      final data = await _repository.fetchDepartments(url);

      totalCount = data['count'] ?? 0;
      nextPageUrl = data['next'];
      previousPageUrl = data['previous'];

      final List<dynamic> list = data['results'] ?? [];
      departments = list
          .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
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
      await fetchDepartments(url: nextPageUrl, isNext: true);
    }
  }

  Future<void> loadPreviousPage() async {
    if (previousPageUrl != null && !isLoadingMore) {
      await fetchDepartments(url: previousPageUrl, isPrev: true);
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
      final success = await _repository.createDepartment(name);
      if (success) {
        await fetchDepartments(refresh: true);
        _snack(context, 'Department created', isError: false);
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
      final success = await _repository.updateDepartment(id, name);
      if (success) {
        await fetchDepartments(refresh: true);
        _snack(context, 'Department updated', isError: false);
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
      final success = await _repository.deleteDepartment(id);
      if (success) {
        departments.removeWhere((d) => d.id == id);
        notifyListeners();
        _snack(context, 'Department deleted', isError: false);
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
