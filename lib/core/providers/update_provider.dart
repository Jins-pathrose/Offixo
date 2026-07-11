import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:offixoadmin/core/services/update_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum UpdateState { none, checking, available, downloading, downloaded, error }

class UpdateProvider with ChangeNotifier {
  final UpdateService _updateService = UpdateService();

  UpdateState _state = UpdateState.none;
  UpdateState get state => _state;

  AppUpdateInfo? _updateInfo;
  AppUpdateInfo? get updateInfo => _updateInfo;

  PackageInfo? _packageInfo;
  PackageInfo? get packageInfo => _packageInfo;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UpdateProvider() {
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    notifyListeners();
  }

  void _setState(UpdateState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Checks for available updates and updates state accordingly.
  Future<void> checkForUpdate() async {
    _setState(UpdateState.checking);
    _errorMessage = null;

    try {
      final info = await _updateService.checkForUpdate();
      _updateInfo = info;

      if (info?.updateAvailability == UpdateAvailability.updateAvailable) {
        _setState(UpdateState.available);
      } else if (info?.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        // Resume immediate update if it was in progress
        await _updateService.performImmediateUpdate();
      } else {
        _setState(UpdateState.none);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UpdateState.error);
    }
  }

  /// Handles the update process based on the configured strategy.
  Future<void> handleUpdate(UpdateStrategy strategy) async {
    if (_updateInfo == null) return;

    try {
      if (strategy == UpdateStrategy.immediate) {
        // Note: performImmediateUpdate will launch a native UI that blocks until finished.
        await _updateService.performImmediateUpdate();
      } else if (strategy == UpdateStrategy.flexible) {
        _setState(UpdateState.downloading);
        await _updateService.startFlexibleUpdate();
        _setState(UpdateState.downloaded);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UpdateState.error);
    }
  }

  /// Completes the flexible update (prompts to install).
  Future<void> completeFlexibleUpdate() async {
    try {
      await _updateService.completeFlexibleUpdate();
    } catch (e) {
      _errorMessage = e.toString();
      _setState(UpdateState.error);
    }
  }
}
