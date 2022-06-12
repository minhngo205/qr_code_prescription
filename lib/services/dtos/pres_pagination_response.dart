import 'package:qr_code_prescription/services/dtos/prescription.dart';

import 'base/pagination_link.dart';

class PrescriptionPaginationResponse {
  PrescriptionPaginationResponse({
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
  List<Prescription> results;

  factory PrescriptionPaginationResponse.fromJson(Map<String, dynamic> json) =>
      PrescriptionPaginationResponse(
        links: Links.fromJson(json["links"]),
        total: json["total"],
        page: json["page"],
        pageSize: json["page_size"],
        results: List<Prescription>.from(
            json["results"].map((x) => Prescription.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "links": links.toJson(),
        "total": total,
        "page": page,
        "page_size": pageSize,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
