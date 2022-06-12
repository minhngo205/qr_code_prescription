import 'package:flutter/material.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
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
    debugPrint("register called: $phoneNo - $password - $fullname");
    final response = await http.post(
      Uri.parse(baseURL + "/patients/register"),
      body: {
        'phone_number': phoneNo,
        'password': password,
        'name': fullname,
      },
    );
    var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      UserInfo userInfo = UserInfo.fromJson(convertedDataToJson);
      _storageRepository.saveUserInfo(userInfo);
      return "Success";
    } else {
      var data = Map<String, dynamic>.from(convertedDataToJson);
      if (data["phone_number"] != null) {
        debugPrint(data["phone_number"][0]);
        return data["phone_number"][0];
      }
      if (data["password"] != null) {
        debugPrint(data["password"][0]);
        return data["password"][0];
      }
    }
  }

  Future<bool> refreshToken() async {
    debugPrint("Refresh Token");
    String? refreshToken = await _storageRepository.getRefreshToken();
    if (refreshToken == null) {
      return false;
    }
    final response = await http.post(
      Uri.parse(baseURL + "/token/refresh"),
      body: {
        'refresh': refreshToken,
      },
    );
    if (response.statusCode == 200) {
      var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      var data = Map<String, dynamic>.from(convertedDataToJson);
      debugPrint(data.toString());
      await _storageRepository.saveAccessToken(data['access']);
      return true;
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return false;
    }
  }

  Future login(String phoneNo, String password) async {
    debugPrint("login called");
    final response = await http.post(
      Uri.parse(baseURL + "/token"),
      body: {
        'phone_number': phoneNo,
        'password': password,
      },
    );
    var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
    var data = Map<String, dynamic>.from(convertedDataToJson);
    debugPrint(data.toString());
    if (data["detail"] != null) {
      return data["detail"];
    } else {
      _storageRepository.saveRefreshToken(data["refresh"]);
      _storageRepository.saveAccessToken(data["access"]);
      debugPrint(
          "Refresh Token: " + _storageRepository.getRefreshToken().toString());
      debugPrint(
          "Access Token: " + _storageRepository.getAccessToken().toString());
      // await _userRepository.getUserInfo();
      return "Success";
    }
  }
}
