/// Exception thrown when there is a server error
class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when there is a cache error
class CacheException implements Exception {
  final String message;

  CacheException(this.message);

  @override
  String toString() => message;
}
