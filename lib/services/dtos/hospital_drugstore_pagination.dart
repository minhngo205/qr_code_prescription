import 'package:qr_code_prescription/services/dtos/hospital_drugstore.dart';

import 'base/pagination_link.dart';

class HospitalDrugstorePagination {
  HospitalDrugstorePagination({
    required this.links,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.results,
  });

  Links links;
  int total;
  int page;
  int pageSize;
  List<HospitalDrugstore> results;

  factory HospitalDrugstorePagination.fromJson(Map<String, dynamic> json) =>
      HospitalDrugstorePagination(
        links: Links.fromJson(json["links"]),
        total: json["total"],
        page: json["page"],
        pageSize: json["page_size"],
        results: List<HospitalDrugstore>.from(
            json["results"].map((x) => HospitalDrugstore.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "links": links.toJson(),
        "total": total,
        "page": page,
        "page_size": pageSize,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
