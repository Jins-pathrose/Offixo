import 'package:flutter/material.dart';
import 'package:offixoadmin/features/medicines/data/model/selected_medicine_model.dart';
import 'package:offixoadmin/features/medicines/data/repository/medicine_repository.dart';

enum SelectedMedicineLoadState { idle, loading, loaded, error }

class SelectedMedicineProvider extends ChangeNotifier {
  final int attendanceId;
  final MedicineRepository _repository = MedicineRepository();

  SelectedMedicineLoadState state = SelectedMedicineLoadState.idle;
  SelectedMedicineData? data;
  String? error;

  SelectedMedicineProvider({required this.attendanceId}) {
    fetchSelectedMedicines();
  }

  Future<void> fetchSelectedMedicines() async {
    state = SelectedMedicineLoadState.loading;
    error = null;
    notifyListeners();

    try {
      final responseData = await _repository.fetchSelectedMedicines(attendanceId);
      data = SelectedMedicineData.fromJson(responseData);
      state = SelectedMedicineLoadState.loaded;
    } catch (e) {
      error = 'Network error: $e';
      state = SelectedMedicineLoadState.error;
    } finally {
      notifyListeners();
    }
  }
}
