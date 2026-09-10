import 'package:flutter/material.dart';
import 'package:offixoadmin/features/medicines/data/model/medicine_model.dart';
import 'package:offixoadmin/features/medicines/data/repository/medicine_repository.dart';

enum MedicineLoadState { idle, loading, loaded, error }

class MedicineProvider extends ChangeNotifier {
  final MedicineRepository _repository = MedicineRepository();

  MedicineLoadState state = MedicineLoadState.idle;
  List<MedicineModel> medicines = [];
  String? error;
  bool isSubmitting = false;

  bool isLoading = false;
  bool isLoadingMore = false;

  String? nextPageUrl;
  String? previousPageUrl;
  int totalCount = 0;
  int currentPage = 1;

  MedicineProvider() {
    fetchMedicines();
  }

  // ── Fetch ──
  Future<void> fetchMedicines({
    bool refresh = false,
    String? url,
    bool isNext = false,
    bool isPrev = false,
  }) async {
    if (refresh) {
      medicines.clear();
      nextPageUrl = null;
      previousPageUrl = null;
      totalCount = 0;
      currentPage = 1;
      url = null;
    }

    if (medicines.isEmpty && url == null) {
      state = MedicineLoadState.loading;
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
      final data = await _repository.fetchMedicines(url);

      totalCount = data['count'] ?? 0;
      nextPageUrl = data['next'];
      previousPageUrl = data['previous'];

      final List<dynamic> list = data['results'] ?? [];
      medicines = list
          .map((e) => MedicineModel.fromJson(e as Map<String, dynamic>))
          .toList();

      state = MedicineLoadState.loaded;

      if (isNext) currentPage++;
      if (isPrev && currentPage > 1) currentPage--;

    } catch (e) {
      error = 'Network error: $e';
      state = MedicineLoadState.error;
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (nextPageUrl != null && !isLoadingMore) {
      await fetchMedicines(url: nextPageUrl, isNext: true);
    }
  }

  Future<void> loadPreviousPage() async {
    if (previousPageUrl != null && !isLoadingMore) {
      await fetchMedicines(url: previousPageUrl, isPrev: true);
    }
  }

  // ── Create ──
  Future<bool> create({
    required String name,
    required String code,
    required String description,
    required bool isActive,
    required BuildContext context,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final success = await _repository.createMedicine(name, code, description, isActive);
      if (success) {
        await fetchMedicines(refresh: true);
        _snack(context, 'Medicine created', isError: false);
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
    required String code,
    required String description,
    required bool isActive,
    required BuildContext context,
  }) async {
    isSubmitting = true;
    notifyListeners();
    try {
      final success = await _repository.updateMedicine(id, name, code, description, isActive);
      if (success) {
        await fetchMedicines(refresh: true);
        _snack(context, 'Medicine updated', isError: false);
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
      final success = await _repository.deleteMedicine(id);
      if (success) {
        medicines.removeWhere((m) => m.id == id);
        notifyListeners();
        _snack(context, 'Medicine deleted', isError: false);
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
