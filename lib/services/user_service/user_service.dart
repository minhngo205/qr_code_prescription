import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_prescription/services/authentication/authentication_service.dart';
import 'package:qr_code_prescription/services/dtos/pagination_response.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_prescription/utils/constants.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  late final StorageRepository _storageRepository;
  late final AuthenticationRepository _authenticationRepository;

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal() {
    _storageRepository = StorageRepository();
    _authenticationRepository = AuthenticationRepository();
  }

  Future<UserInfo?> getUserInfo() async {
    bool isSuccess = await _authenticationRepository.refreshToken();
    if (!isSuccess) {
      debugPrint("Can not refresh token");
      return null;
    }
    String? token = await _storageRepository.getAccessToken();
    final response = await http.get(
      Uri.parse(baseURL + "/patients/a/info"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint(utf8.decode(response.bodyBytes));
    // ignore: prefer_typing_uninitialized_variables
    var convertedDataToJson;
    if (response.statusCode == 200) {
      convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      UserInfo userInfo = UserInfo.fromJson(convertedDataToJson);
      await _storageRepository.saveUserInfo(userInfo);
      return userInfo;
    } else {
      convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      return null;
    }
  }

  Future getUserPrescriptionList(int page, int pageSize) async {
    await _authenticationRepository.refreshToken();
    String? token = await _storageRepository.getAccessToken();
    final response = await http.get(
      Uri.parse(baseURL + "/patients/a/prescriptions"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    debugPrint(utf8.decode(response.bodyBytes));
    // ignore: prefer_typing_uninitialized_variables
    var convertedDataToJson;
    if (response.statusCode == 200) {
      convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      return PrescriptionPaginationResponse.fromJson(convertedDataToJson)
          .results
          ?.sublist(
            0,
            pageSize,
          );
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return null;
    }
  }

  Future<String> getPresToken(String id) async {
    bool isSuccess = await _authenticationRepository.refreshToken();
    if (!isSuccess) {
      debugPrint("Can not refresh token");
      return "Failed";
    }
    String? token = await _storageRepository.getAccessToken();
    final response = await http.get(
      Uri.parse(
        baseURL + "/patients/a/prescriptions/$id/token",
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // ignore: prefer_typing_uninitialized_variables
    var convertedDataToJson;
    // ignore: prefer_typing_uninitialized_variables
    var data;

    if (response.statusCode == 200) {
      convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      data = Map<String, dynamic>.from(convertedDataToJson);
      debugPrint(data['prescription_token']);
      return data['prescription_token'];
    } else {
      convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      data = Map<String, dynamic>.from(convertedDataToJson);
      if (data['detail'] != null || data['detail'].toString().isNotEmpty) {
        return data['detail'];
      } else {
        return "Failed";
      }
    }
  }
}
