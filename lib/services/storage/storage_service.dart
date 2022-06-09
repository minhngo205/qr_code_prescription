import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';

class StorageRepository {
  static final StorageRepository _instance = StorageRepository._internal();
  late FlutterSecureStorage _localStorage;

  factory StorageRepository() {
    return _instance;
  }

  StorageRepository._internal() {
    _localStorage = const FlutterSecureStorage();
  }

  saveAccessToken(String accessToken) async {
    await _localStorage.write(key: "AccessToken", value: accessToken);
  }

  void saveRefreshToken(String refreshToken) async {
    await _localStorage.write(key: "RefreshToken", value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _localStorage.read(key: "AccessToken");
  }

  Future<String?> getRefreshToken() {
    return _localStorage.read(key: "RefreshToken");
  }

  void deleteToken() async {
    await _localStorage.delete(key: "AccessToken");
    await _localStorage.delete(key: "RefreshToken");
  }

  saveUserInfo(UserInfo userInfo) async {
    await _localStorage.write(
        key: "UserInfo", value: json.encode(userInfo.toJson()));
  }

  Future<UserInfo?> getUserInfo() async {
    final user = await _localStorage.read(key: "UserInfo");
    if (user?.isNotEmpty ?? false) {
      UserInfo userInfo = UserInfo.fromJson(json.decode(user!));
      debugPrint(userInfo.name);
      return userInfo;
    }
    return null;
  }
}
