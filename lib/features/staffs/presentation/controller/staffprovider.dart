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

  Future<void> loadStaffs({String? url, bool isRefresh = false, bool loadMore = false}) async {
    if (isRefresh) {
      nextUrl = null;
      _allStaffs.clear();
      currentPage = 1;
      state = StaffLoadState.loading;
      notifyListeners();
    } else if (loadMore) {
      if (nextUrl == null || isNextLoading) return;
      isNextLoading = true;
      notifyListeners();
    } else if (url == null && _allStaffs.isEmpty) {
      state = StaffLoadState.loading;
      notifyListeners();
    } else if (url == null) {
      return;
    }

    try {
      final urlToFetch = loadMore ? nextUrl : url;
      final response = await _repository.fetchStaffs(url: urlToFetch);
      
      if (loadMore) {
        _allStaffs.addAll(response.results);
      } else {
        _allStaffs = response.results;
      }
      
      totalCount = response.count;
      nextUrl = response.next;

      if (url == null && !loadMore) {
        currentPage = 1;
      }

      _applyFilter();
      state = StaffLoadState.loaded;
    } catch (e) {
      if (!loadMore) {
        if (url == null || isRefresh) {
          errorMessage = e.toString();
          state = StaffLoadState.error;
        } else {
          rethrow;
        }
      } else {
        errorMessage = e.toString();
        // Rethrow so the UI can catch it and show a Snackbar
        rethrow;
      }
    } finally {
      if (loadMore) {
        isNextLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> fetchNextPage(BuildContext context) async {
    if (nextUrl == null || isNextLoading) return;

    try {
      await loadStaffs(loadMore: true);
      currentPage++;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load next page')),
        );
      }
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