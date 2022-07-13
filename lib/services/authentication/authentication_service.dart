import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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

  Future register(
    String phoneNo,
    String password,
    String fullname,
    String otpCode,
  ) async {
    debugPrint("register called: $phoneNo - $password - $fullname");
    final response = await http.put(
      Uri.parse(baseURL + "/patients/register"),
      body: {
        'phone_number': phoneNo,
        'password': password,
        'name': fullname,
        'otp_code': otpCode,
      },
    );

    var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
    debugPrint(convertedDataToJson.toString());

    if (response.statusCode == 200) {
      _storageRepository.saveRefreshToken(convertedDataToJson["refresh"]);
      _storageRepository.saveAccessToken(convertedDataToJson["access"]);
      debugPrint(
          "Refresh Token: " + _storageRepository.getRefreshToken().toString());
      debugPrint(
          "Access Token: " + _storageRepository.getAccessToken().toString());
      // await _userRepository.getUserInfo();
      return "Success";
    } else {
      var data = Map<String, dynamic>.from(convertedDataToJson);
      if (data["detail"] != null) {
        return data["detail"];
      }
    }
  }

  Future<bool> refreshToken() async {
    debugPrint("Refresh Token");
    String? refreshToken = await _storageRepository.getRefreshToken();
    if (refreshToken == null || JwtDecoder.isExpired(refreshToken)) {
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

  Future<String> requestOTP(String phoneNo) async {
    var response = await http.put(
      Uri.parse("$baseURL/users/otp"),
      body: {
        'phone_number': phoneNo,
      },
    );

    if (response.statusCode == 200) {
      return "Success";
    } else {
      var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      return convertedDataToJson['detail'];
    }
  }
}
