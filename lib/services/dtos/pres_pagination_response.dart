import 'package:qr_code_prescription/services/dtos/prescription.dart';

import 'base/pagination_link.dart';
import 'doctor.dart';
import 'medicine_list.dart';

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

// class Result {
//     Result({
//         required this.id,
//         required this.medicineItems,
//         required this.doctor,
//         required this.status,
//         required this.diagnostic,
//         required this.note,
//         required this.createdAt,
//         required this.updatedAt,
//         this.pharmacist,
//     });

//     int id;
//     List<MedicineItem> medicineItems;
//     Doctor doctor;
//     String status;
//     String diagnostic;
//     String note;
//     DateTime createdAt;
//     DateTime updatedAt;
//     int pharmacist;

//     factory Result.fromJson(Map<String, dynamic> json) => Result(
//         id: json["id"],
//         medicineItems: List<MedicineItem>.from(json["medicine_items"].map((x) => MedicineItem.fromJson(x))),
//         doctor: Doctor.fromJson(json["doctor"]),
//         status: json["status"],
//         diagnostic: json["diagnostic"],
//         note: json["note"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         pharmacist: json["pharmacist"] == null ? null : json["pharmacist"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "medicine_items": List<dynamic>.from(medicineItems.map((x) => x.toJson())),
//         "doctor": doctor.toJson(),
//         "status": status,
//         "diagnostic": diagnostic,
//         "note": note,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "pharmacist": pharmacist == null ? null : pharmacist,
//     };
// }