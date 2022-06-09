import 'package:qr_code_prescription/services/dtos/base/pagination_base.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';

class PrescriptionPaginationResponse extends PaginationBase {
  List<Prescription>? results;

  PrescriptionPaginationResponse({this.results});

  PrescriptionPaginationResponse.fromJson(Map<String, dynamic> json) {
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    total = json['total'];
    page = json['page'];
    pageSize = json['page_size'];
    if (json['results'] != null) {
      results = <Prescription>[];
      json['results'].forEach((v) {
        results!.add(Prescription.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (links != null) {
      data['links'] = links!.toJson();
    }
    data['total'] = total;
    data['page'] = page;
    data['page_size'] = pageSize;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
