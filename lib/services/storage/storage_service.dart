import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_code_prescription/services/authentication/dtos/user_info.dart';

class StorageRepository {
  static final StorageRepository _instance = StorageRepository._internal();
  late FlutterSecureStorage _localStorage;

  factory StorageRepository() {
    return _instance;
  }

  StorageRepository._internal() {
    _localStorage = const FlutterSecureStorage();
  }

  void saveToken(String refreshToken, String accessToken) async {
    // await _localStorage.write(key: "isLoggedIn", value: true);
    await _localStorage.write(key: "AccessToken", value: accessToken);
    await _localStorage.write(key: "RefreshToken", value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _localStorage.read(key: "AccessToken");
  }

  Future<String?> getRefreshToken() {
    return _localStorage.read(key: "RefreshToken");
  }

  void saveUserInfo(UserInfo userInfo) async {
    await _localStorage.write(
        key: "UserInfo", value: json.encode(userInfo.toJson()));
  }

  Future<UserInfo?> getUserInfo() async {
    final user = await _localStorage.read(key: "UserInfo");
    if (user?.isNotEmpty ?? false) return UserInfo.fromJson(json.decode(user!));
    return null;
  }
}
