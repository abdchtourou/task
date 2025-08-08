import 'connectivity_checker.dart';

class NetworkHelper {
  static final ConnectivityChecker _connectivityChecker =
      ConnectivityChecker.instance;

  static Future<void> initialize() async {
    await _connectivityChecker.initialize();
  }

  static Future<bool> get isConnected => _connectivityChecker.hasConnection;

  static Future<bool> get hasStrongConnection =>
      _connectivityChecker.hasStrongConnection;

  static NetworkStatus get currentStatus => _connectivityChecker.currentStatus;

  static Stream<NetworkStatus> get statusStream =>
      _connectivityChecker.networkStatusStream;

  static Future<Map<String, dynamic>> getConnectionDetails() =>
      _connectivityChecker.getConnectionDetails();

  static bool get shouldUseCache => _connectivityChecker.shouldUseCache;

  static bool get shouldFetchFromRemote =>
      _connectivityChecker.shouldFetchFromRemote;

  static Future<void> waitForConnection({Duration? timeout}) =>
      _connectivityChecker.waitForConnection(
        timeout: timeout ?? const Duration(seconds: 30),
      );

  static Future<T> executeWhenConnected<T>(
    Future<T> Function() function, {
    Duration timeout = const Duration(seconds: 30),
    T? fallbackValue,
  }) async {
    try {
      if (await isConnected) {
        return await function();
      }

      await waitForConnection(timeout: timeout);
      return await function();
    } catch (e) {
      if (fallbackValue != null) {
        return fallbackValue;
      }
      rethrow;
    }
  }

  static Future<T> executeWithFallback<T>(
    Future<T> Function() onlineFunction,
    Future<T> Function() offlineFunction,
  ) async {
    if (await isConnected) {
      try {
        return await onlineFunction();
      } catch (e) {

        return await offlineFunction();
      }
    } else {
      return await offlineFunction();
    }
  }

  static void dispose() {
    _connectivityChecker.dispose();
  }
}

