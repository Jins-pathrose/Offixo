import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/foundation.dart';

enum UpdateStrategy { immediate, flexible }

class UpdateService {
  // Configurable update strategy
  static const UpdateStrategy defaultStrategy = UpdateStrategy.flexible;

  /// Checks if an update is available on the Play Store.
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
        return null; // In-app updates are Android only
      }
      
      final info = await InAppUpdate.checkForUpdate();
      return info;
    } catch (e) {
      debugPrint('Error checking for update: $e');
      return null;
    }
  }

  /// Performs an immediate update (blocks UI until updated).
  Future<void> performImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      debugPrint('Error performing immediate update: $e');
      rethrow;
    }
  }

  /// Starts a flexible update (downloads in background).
  Future<void> startFlexibleUpdate() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
    } catch (e) {
      debugPrint('Error starting flexible update: $e');
      rethrow;
    }
  }

  /// Completes a flexible update (prompts to install).
  Future<void> completeFlexibleUpdate() async {
    try {
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      debugPrint('Error completing flexible update: $e');
      rethrow;
    }
  }
}
