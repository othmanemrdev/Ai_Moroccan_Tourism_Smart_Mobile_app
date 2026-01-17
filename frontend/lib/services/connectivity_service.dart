import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  /// Check if device is currently online
  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }
  
  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (results) => results.first != ConnectivityResult.none
    );
  }
}
