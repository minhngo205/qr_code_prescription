import 'package:flutter/material.dart';
import 'package:qr_code_prescription/services/authentication/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationRepository {
  static final AuthenticationRepository _instance =
      AuthenticationRepository._internal();
  late final StorageRepository _storageRepository;

  factory AuthenticationRepository() {
    return _instance;
  }

  AuthenticationRepository._internal() {
    // initialization logic
    _storageRepository = StorageRepository();
  }

  Future register(String phoneNo, String password, String fullname) async {
    debugPrint("register called");
    final response = await http.post(
      Uri.parse(baseURL + "/register"),
      body: {
        'phone_number': phoneNo,
        'password': password,
        'name': fullname,
      },
    );
    var convertedDataToJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      UserInfo userInfo = UserInfo.fromJson(convertedDataToJson);
      _storageRepository.saveUserInfo(userInfo);
      return "Success";
    } else {
      var data = Map<String, dynamic>.from(convertedDataToJson);
      if (data["username"] != null) {
        debugPrint(data["username"]);
        return data["username"];
      }
      if (data["password"] != null) {
        debugPrint(data["password"]);
        return data["password"];
      }
    }
  }

  Future login(String phoneNo, String password) async {
    debugPrint("login called");
    final response = await http.post(
      Uri.parse(baseURL + "/token/"),
      body: {
        'phone_number': phoneNo,
        'password': password,
      },
    );
    var convertedDataToJson = jsonDecode(response.body);
    var data = Map<String, dynamic>.from(convertedDataToJson);
    debugPrint(data.toString());
    if (data["detail"] != null) {
      return data["detail"];
    } else {
      _storageRepository.saveToken(data["refresh"], data["access"]);
      debugPrint(
          "Refresh Token: " + _storageRepository.getRefreshToken().toString());
      debugPrint(
          "Access Token: " + _storageRepository.getAccessToken().toString());
      return "Success";
    }
  }
}
