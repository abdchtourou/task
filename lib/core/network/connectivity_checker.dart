import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { connected, disconnected, weak }

class ConnectivityChecker {
  static ConnectivityChecker? _instance;
  static ConnectivityChecker get instance =>
      _instance ??= ConnectivityChecker._();

  ConnectivityChecker._();

  final Connectivity _connectivity = Connectivity();
  StreamController<NetworkStatus>? _networkStatusController;
  NetworkStatus _currentStatus = NetworkStatus.disconnected;

  Stream<NetworkStatus> get networkStatusStream {
    _networkStatusController ??= StreamController<NetworkStatus>.broadcast();
    return _networkStatusController!.stream;
  }

  NetworkStatus get currentStatus => _currentStatus;

  Future<bool> get hasConnection async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      return await _checkInternetAccess();
    } catch (e) {
      return false;
    }
  }

  Future<bool> get hasStrongConnection async {
    final status = await getNetworkStatus();
    return status == NetworkStatus.connected;
  }

  Future<NetworkStatus> getNetworkStatus() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        return NetworkStatus.disconnected;
      }

      final hasInternet = await _checkInternetAccess();
      if (!hasInternet) {
        return NetworkStatus.disconnected;
      }

      final connectionQuality = await _checkConnectionQuality();
      return connectionQuality;
    } catch (e) {
      return NetworkStatus.disconnected;
    }
  }

  Future<void> initialize() async {
    _networkStatusController ??= StreamController<NetworkStatus>.broadcast();

    _currentStatus = await getNetworkStatus();
    _networkStatusController!.add(_currentStatus);

    _connectivity.onConnectivityChanged.listen(
      (results) => _onConnectivityChanged(results.first),
    );
  }

  void _onConnectivityChanged(ConnectivityResult result) async {
    final newStatus = await getNetworkStatus();
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _networkStatusController?.add(_currentStatus);
    }
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final results = await Future.wait([
        _pingHost('8.8.8.8', 53),
        _pingHost('1.1.1.1', 53),
      ]);

      return results.any((result) => result);
    } catch (e) {
      return false;
    }
  }

  Future<bool> _pingHost(String host, int port) async {
    try {
      final socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<NetworkStatus> _checkConnectionQuality() async {
    try {
      final stopwatch = Stopwatch()..start();

      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(seconds: 5),
      );

      stopwatch.stop();
      socket.destroy();

      final responseTime = stopwatch.elapsedMilliseconds;

      if (responseTime < 1000) {
        return NetworkStatus.connected;
      } else if (responseTime < 3000) {
        return NetworkStatus.weak;
      } else {
        return NetworkStatus.disconnected;
      }
    } catch (e) {
      return NetworkStatus.disconnected;
    }
  }

  Future<Map<String, dynamic>> getConnectionDetails() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      final hasInternet = await _checkInternetAccess();
      final status = await getNetworkStatus();

      return {
        'type': connectivityResult.toString().split('.').last,
        'hasInternet': hasInternet,
        'status': status.name,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'type': 'unknown',
        'hasInternet': false,
        'status': NetworkStatus.disconnected.name,
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
      };
    }
  }

  bool get shouldUseCache {
    return _currentStatus == NetworkStatus.disconnected ||
        _currentStatus == NetworkStatus.weak;
  }

  bool get shouldFetchFromRemote {
    return _currentStatus == NetworkStatus.connected;
  }

  Future<void> waitForConnection({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (await hasConnection) return;

    final completer = Completer<void>();
    StreamSubscription? subscription;

    final timer = Timer(timeout, () {
      subscription?.cancel();
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException('Connection timeout', timeout),
        );
      }
    });

    subscription = networkStatusStream.listen((status) {
      if (status == NetworkStatus.connected) {
        timer.cancel();
        subscription?.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    return completer.future;
  }

  void dispose() {
    _networkStatusController?.close();
    _networkStatusController = null;
  }
}
