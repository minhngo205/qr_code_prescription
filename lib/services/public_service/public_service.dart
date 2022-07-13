import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_prescription/model/dtos/hospital_drugstore.dart';
import 'package:qr_code_prescription/model/dtos/hospital_drugstore_pagination.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class PublicService {
  static final PublicService _instance = PublicService._internal();

  factory PublicService() {
    return _instance;
  }

  PublicService._internal() {
    // initialization logic
  }

  Future getPaginationHospital(String pageName, int page, int pageSize) async {
    final response = await http
        .get(Uri.parse(baseURL + "/$pageName?page=$page&page_size=$pageSize"));
    // debugPrint(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      return HospitalDrugstorePagination.fromJson(convertedDataToJson);
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return null;
    }
  }

  Future<HospitalDrugstore?> getDetailHospital(String role, int id) async {
    final response = await http.get(
      Uri.parse(baseURL + "/$role/$id"),
    );
    // debugPrint(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      var convertedDataToJson = jsonDecode(utf8.decode(response.bodyBytes));
      return HospitalDrugstore.fromJson(convertedDataToJson);
    } else {
      debugPrint(utf8.decode(response.bodyBytes));
      return null;
    }
  }
}
