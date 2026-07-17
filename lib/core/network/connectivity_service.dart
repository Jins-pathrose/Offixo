import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  // Singleton pattern
  ConnectivityService._privateConstructor();
  static final ConnectivityService instance = ConnectivityService._privateConstructor();

  final Connectivity _connectivity = Connectivity();
  final InternetConnection _internetConnection = InternetConnection();

  /// Checks if the device has an active internet connection.
  /// It first checks the connection type (Wi-Fi, Mobile, etc.)
  /// and then verifies actual internet reachability.
  Future<bool> get isConnected async {
    // First check if there is any network interface connected
    final List<ConnectivityResult> connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult.isEmpty || connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    // Then check if it actually has internet access
    return await _internetConnection.hasInternetAccess;
  }
}
