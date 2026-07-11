import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/update_provider.dart';
import '../services/update_service.dart';

class UpdateDialog extends StatelessWidget {
  final bool isImmediate;

  const UpdateDialog({
    super.key,
    this.isImmediate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateProvider>(
      builder: (context, updateProvider, child) {
        final currentVersion = updateProvider.packageInfo?.version ?? 'Unknown';
        final currentBuild = updateProvider.packageInfo?.buildNumber ?? '';
        final newVersionCode = updateProvider.updateInfo?.availableVersionCode?.toString() ?? 'Unknown';

        final isLoading = updateProvider.state == UpdateState.downloading ||
                          updateProvider.state == UpdateState.checking;

        return WillPopScope(
          onWillPop: () async => !isImmediate, // Prevent dismissal if immediate
          child: AlertDialog(
            title: const Text('Update Available'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('A new version of the app is available. Please update to continue.'),
                const SizedBox(height: 16),
                Text('Current Version: $currentVersion ($currentBuild)'),
                Text('New Version Code: $newVersionCode'),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (updateProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Error: ${updateProvider.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
            actions: [
              if (!isImmediate && !isLoading)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Later'),
                ),
              if (!isLoading)
                ElevatedButton(
                  onPressed: () {
                    final strategy = isImmediate ? UpdateStrategy.immediate : UpdateStrategy.flexible;
                    updateProvider.handleUpdate(strategy).then((_) {
                      if (strategy == UpdateStrategy.flexible &&
                          updateProvider.state == UpdateState.downloaded) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                  child: const Text('Update Now'),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// A wrapper widget to show restart prompt after flexible update downloads
class FlexibleUpdateRestartPrompt extends StatelessWidget {
  const FlexibleUpdateRestartPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateProvider>(
      builder: (context, updateProvider, child) {
        if (updateProvider.state != UpdateState.downloaded) {
          return const SizedBox.shrink(); // Hide if not downloaded
        }

        return Material(
          color: Colors.blueAccent,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Update downloaded. Restart to install.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      updateProvider.completeFlexibleUpdate();
                    },
                    child: const Text(
                      'RESTART',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
