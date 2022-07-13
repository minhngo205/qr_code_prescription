import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_code_prescription/model/dtos/prescription.dart';
import 'package:qr_code_prescription/model/dtos/user_info.dart';

import '../../model/dtos/prescription_item.dart';

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

  saveRefreshToken(String refreshToken) async {
    await _localStorage.write(key: "RefreshToken", value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _localStorage.read(key: "AccessToken");
  }

  Future<String?> getRefreshToken() async {
    return await _localStorage.read(key: "RefreshToken");
  }

  void deleteToken() async {
    await _localStorage.delete(key: "AccessToken");
    await _localStorage.delete(key: "RefreshToken");
    await _localStorage.delete(key: "UserInfo");
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

  savePrescriptionList(List<PrescriptionItem> listPres) async {
    List<String> savedList =
        listPres.map((e) => json.encode(e.toJson())).toList();
    await _localStorage.write(key: 'listofpres', value: jsonEncode(savedList));
  }

  Future<List<Prescription>?> getPrescriptionList() async {
    String? stringofitems = await _localStorage.read(key: 'listofpres');
    if (stringofitems?.isNotEmpty ?? false) {
      List<dynamic> listofitems = jsonDecode(stringofitems!);
      List<Prescription> result = listofitems
          .map((e) => Prescription.fromJson(json.decode(e)))
          .toList();
      return result;
    }
    return [];
  }
}
