// lib/features/staffs/presentation/providers/staff_provider.dart

import 'package:flutter/material.dart';

import 'package:offixoadmin/features/staffs/data/staffmodel.dart';
import 'package:offixoadmin/features/staffs/domain/staffrepository.dart';

enum StaffLoadState { idle, loading, loaded, error }

class StaffProvider extends ChangeNotifier {
  final StaffRepository _repository = StaffRepository();

  List<StaffModel> _allStaffs = [];
  List<StaffModel> _filteredStaffs = [];
  StaffLoadState state = StaffLoadState.idle;
  String errorMessage = '';
  String _searchQuery = '';

  int totalCount = 0;
  String? nextUrl;
  String? previousUrl;
  int currentPage = 1;

  bool isNextLoading = false;
  bool isPreviousLoading = false;

  List<StaffModel> get staffs => _filteredStaffs;

  Future<void> loadStaffs({String? url, bool isRefresh = false}) async {
    if (url == null && !isRefresh) {
      state = StaffLoadState.loading;
      notifyListeners();
    }

    try {
      final response = await _repository.fetchStaffs(url: url);
      _allStaffs = response.results;
      totalCount = response.count;
      nextUrl = response.next;
      previousUrl = response.previous;

      if (url == null) {
        currentPage = 1; // reset if it's initial load or refresh without url
      }

      _applyFilter();
      state = StaffLoadState.loaded;
    } catch (e) {
      if (url == null) {
        errorMessage = e.toString();
        state = StaffLoadState.error;
      } else {
        rethrow;
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchNextPage(BuildContext context) async {
    if (nextUrl == null || isNextLoading) return;

    isNextLoading = true;
    notifyListeners();

    try {
      await loadStaffs(url: nextUrl);
      currentPage++;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load next page')),
        );
      }
    } finally {
      isNextLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPreviousPage(BuildContext context) async {
    if (previousUrl == null || isPreviousLoading) return;

    isPreviousLoading = true;
    notifyListeners();

    try {
      await loadStaffs(url: previousUrl);
      currentPage--;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load previous page')),
        );
      }
    } finally {
      isPreviousLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredStaffs = List.from(_allStaffs);
    } else {
      _filteredStaffs = _allStaffs.where((s) {
        return s.fullName.toLowerCase().contains(_searchQuery) ||
            s.empNo.toLowerCase().contains(_searchQuery) ||
            s.phoneNumber.contains(_searchQuery);
      }).toList();
    }
  }
}