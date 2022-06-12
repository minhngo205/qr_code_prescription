import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class Api {
  static final Api _instance = Api._internal();
  Dio dio = Dio();
  String? accessToken;
  final StorageRepository _storageRepository = StorageRepository();

  factory Api() {
    return _instance;
  }

  Api._internal() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.contains('http')) {
            options.path = baseURL + options.path;
          }
          options.headers['Authorization'] = 'Bearer $accessToken';
          return handler.next(options);
        },
        onError: (DioError error, handler) async {
          if (error.response?.statusCode == 401 &&
              error.response?.data['detail'] ==
                  "Given token not valid for any token type") {
            if (await _storageRepository.getRefreshToken() != null) {
              await refreshToken();
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> refreshToken() async {
    debugPrint("Dio refresh token");
    String? refreshToken = await _storageRepository.getRefreshToken();
    final response = await dio.post(
      "/token/refresh",
      data: {
        'refresh': refreshToken,
      },
    );
    debugPrint(response.data.toString());
    if (response.statusCode == 200) {
      accessToken = response.data['access'];
      await _storageRepository.saveAccessToken(accessToken!);
    } else {
      accessToken = null;
      _storageRepository.deleteToken();
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<bool> changePassword(String current, String newPass) async {
    try {
      final response = await dio.post(
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
