import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/auth_user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(AuthUserModel userModel);

  Future<AuthUserModel?> getUser();

  Future<void> clearUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String userKey = 'auth_user';
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveUser(AuthUserModel userModel) async {
    final jsonString = jsonEncode(userModel.toJson());
    await secureStorage.write(key: userKey, value: jsonString);
  }

  @override
  Future<AuthUserModel?> getUser() async {
    final jsonString = await secureStorage.read(key: userKey);
    if (jsonString == null) return null;
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return AuthUserModel.fromJson(map);
  }

  @override
  Future<void> clearUser() async {
    await secureStorage.delete(key: userKey);
  }
}

