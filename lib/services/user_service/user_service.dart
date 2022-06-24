import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:qr_code_prescription/services/authentication/authentication_service.dart';
import 'package:qr_code_prescription/services/dtos/pres_pagination_response.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_prescription/services/user_service/api.dart';
import 'package:qr_code_prescription/utils/constants.dart';

enum RequestStatus { RefreshFail, RequestSuccess, RequestFail }

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

  Future getUserInfo() async {
    String? accessToken = await _storageRepository.getAccessToken();
    if (JwtDecoder.isExpired(accessToken!)) {
      bool isSuccess = await _authenticationRepository.refreshToken();
      if (!isSuccess) {
        debugPrint("Can not refresh token");
        return RequestStatus.RefreshFail;
      }
      accessToken = await _storageRepository.getAccessToken();
    }
    final response = await http.get(
      Uri.parse(baseURL + "/patients/a/info"),
      headers: {
        'Authorization': 'Bearer $accessToken',
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
      return RequestStatus.RequestFail;
    }
  }

  Future getPaginationPres(int page, int pageSize) async {
    String? accessToken = await _storageRepository.getAccessToken();
    if (JwtDecoder.isExpired(accessToken!)) {
      bool isSuccess = await _authenticationRepository.refreshToken();
      if (!isSuccess) {
        debugPrint("Can not refresh token");
        return RequestStatus.RefreshFail;
      }
      accessToken = await _storageRepository.getAccessToken();
    }
    debugPrint("Get Here");
    final response = await http.get(
      Uri.parse(
          baseURL + "/patients/a/prescriptions?page=$page&page_size=$pageSize"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    debugPrint(utf8.decode(response.bodyBytes));
    var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
    debugPrint("Get here three");
    if (response.statusCode == 200) {
      return PrescriptionPaginationResponse.fromJson(convertedDataToJson)
          .results;
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return [];
    }
  }

  Future getUserPrescriptionList(bool isCache, int page, int pageSize) async {
    String? accessToken = await _storageRepository.getAccessToken();
    if (JwtDecoder.isExpired(accessToken!)) {
      bool isSuccess = await _authenticationRepository.refreshToken();
      if (!isSuccess) {
        debugPrint("Can not refresh token");
        return RequestStatus.RefreshFail;
      }
      accessToken = await _storageRepository.getAccessToken();
    }
    final response = await http.get(
      Uri.parse(
          baseURL + "/patients/a/prescriptions?page=$page&page_size=$pageSize"),
      headers: {
        'Authorization': 'Bearer $accessToken',
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

  Future getPresDetail(int presID) async {
    String? accessToken = await _storageRepository.getAccessToken();
    if (JwtDecoder.isExpired(accessToken!)) {
      bool isSuccess = await _authenticationRepository.refreshToken();
      if (!isSuccess) {
        debugPrint("Can not refresh token");
        return RequestStatus.RefreshFail;
      }
      accessToken = await _storageRepository.getAccessToken();
    }
    final response = await http.get(
      Uri.parse(
        baseURL + "/patients/a/prescriptions/$presID",
      ),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      Prescription result = Prescription.fromJson(convertedDataToJson);
      return result;
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return RequestStatus.RequestFail;
    }
  }

  Future getPresToken(String id) async {
    String? accessToken = await _storageRepository.getAccessToken();
    if (JwtDecoder.isExpired(accessToken!)) {
      bool isSuccess = await _authenticationRepository.refreshToken();
      if (!isSuccess) {
        debugPrint("Can not refresh token");
        return RequestStatus.RefreshFail;
      }
      accessToken = await _storageRepository.getAccessToken();
    }
    final response = await http.get(
      Uri.parse(
        baseURL + "/patients/a/prescriptions/$id/token",
      ),
      headers: {
        'Authorization': 'Bearer $accessToken',
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
        return RequestStatus.RequestFail;
      }
    }
  }

  Future updateUserInfo(UserInfo userInfo) async {
    String? accessToken = await _storageRepository.getAccessToken();
    if (JwtDecoder.isExpired(accessToken!)) {
      bool isSuccess = await _authenticationRepository.refreshToken();
      if (!isSuccess) {
        debugPrint("Can not refresh token");
        return RequestStatus.RefreshFail;
      }
      accessToken = await _storageRepository.getAccessToken();
    }
    final response = await http.patch(
      Uri.parse(baseURL + "/patients/a/info"),
      headers: {
        'Authorization': 'Bearer $accessToken',
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
      return RequestStatus.RequestFail;
    }
  }

  Future changePassword(String current, String newPass) async {
    String? accessToken = await _storageRepository.getAccessToken();
    if (JwtDecoder.isExpired(accessToken!)) {
      bool isSuccess = await _authenticationRepository.refreshToken();
      if (!isSuccess) {
        debugPrint("Can not refresh token");
        return RequestStatus.RefreshFail;
      }
      accessToken = await _storageRepository.getAccessToken();
    }
    var response = await http.post(
      Uri.parse(baseURL + "/users/a/change_password"),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
      body: {
        'old_password': current,
        'new_password': newPass,
      },
    );
    var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return RequestStatus.RequestSuccess;
    } else {
      return convertedDataToJson['detail'];
    }
  }
}
