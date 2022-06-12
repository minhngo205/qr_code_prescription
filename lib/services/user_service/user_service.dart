import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/services/authentication/authentication_service.dart';
import 'package:qr_code_prescription/services/dtos/pres_pagination_response.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_prescription/services/user_service/api.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  late final StorageRepository _storageRepository;
  late final AuthenticationRepository _authenticationRepository;
  late final Api api;

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal() {
    _storageRepository = StorageRepository();
    _authenticationRepository = AuthenticationRepository();
    api = Api();
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
      debugPrint(utf8.decode(response.bodyBytes));
      return null;
    }
  }

  Future getPaginationPres(int page, int pageSize) async {
    bool refreshResult = await _authenticationRepository.refreshToken();
    if (!refreshResult) {
      debugPrint("Can not refresh token");
      return null;
    }
    String? token = await _storageRepository.getAccessToken();
    final response = await http.get(
      Uri.parse(
          baseURL + "/patients/a/prescriptions?page=$page&page_size=$pageSize"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // ignore: prefer_typing_uninitialized_variables
    var convertedDataToJson;
    if (response.statusCode == 200) {
      convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      return PrescriptionPaginationResponse.fromJson(convertedDataToJson);
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return null;
    }
  }

  Future getUserPrescriptionList(bool isCache, int page, int pageSize) async {
    bool refreshResult = await _authenticationRepository.refreshToken();
    if (!refreshResult) {
      debugPrint("Can not refresh token");
      return [];
    }
    String? token = await _storageRepository.getAccessToken();
    final response = await http.get(
      Uri.parse(
          baseURL + "/patients/a/prescriptions?page=$page&page_size=$pageSize"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    // ignore: prefer_typing_uninitialized_variables
    var convertedDataToJson;
    if (response.statusCode == 200) {
      convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      List<Prescription>? result =
          PrescriptionPaginationResponse.fromJson(convertedDataToJson).results;
      if (isCache) await _storageRepository.savePrescriptionList(result);
      return result;
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return [];
    }
  }

  Future<Prescription?> getPresDetail(int presID) async {
    bool isSuccess = await _authenticationRepository.refreshToken();
    if (!isSuccess) {
      debugPrint("Can not refresh token");
      return null;
    }
    String? token = await _storageRepository.getAccessToken();
    final response = await http.get(
      Uri.parse(
        baseURL + "/patients/a/prescriptions/$presID",
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      Prescription result = Prescription.fromJson(convertedDataToJson);
      return result;
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

  Future<UserInfo?> updateUserInfo(UserInfo userInfo) async {
    bool isSuccess = await _authenticationRepository.refreshToken();
    if (!isSuccess) {
      debugPrint("Can not refresh token");
      return null;
    }
    String? token = await _storageRepository.getAccessToken();
    final response = await http.patch(
      Uri.parse(baseURL + "/patients/a/info"),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        'name': userInfo.name,
        'gender': userInfo.gender.toString(),
        'dob': apiDateFormat(userInfo.dob),
        'identify_number': userInfo.identifyNumber,
        'social_insurance': userInfo.socialInsurance,
      },
    );
    if (response.statusCode == 200) {
      var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      UserInfo userInfo = UserInfo.fromJson(convertedDataToJson);
      await _storageRepository.saveUserInfo(userInfo);
      return userInfo;
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return null;
    }
  }

  Future<bool> changePassword(String current, String newPass) async {
    try {
      final response = await api.dio.post(
        "/users/a/change_password",
        data: {
          'old_password': current,
          'new_password': newPass,
        },
      );
      debugPrint(response.data.toString());
      return true;
    } on DioError catch (e) {
      debugPrint(e.response!.data.toString());
      return false;
    }
  }
}
