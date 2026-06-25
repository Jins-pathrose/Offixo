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

  List<StaffModel> get staffs => _filteredStaffs;

  Future<void> loadStaffs() async {
    state = StaffLoadState.loading;
    notifyListeners();

    try {
      _allStaffs = await _repository.fetchStaffs();
      _applyFilter();
      state = StaffLoadState.loaded;
    } catch (e) {
      errorMessage = e.toString();
      state = StaffLoadState.error;
    }

    notifyListeners();
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