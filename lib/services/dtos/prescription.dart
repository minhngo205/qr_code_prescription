import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';

import 'medicine_list.dart';
import 'doctor.dart';

class Prescription {
  Prescription({
    required this.id,
    required this.medicineItems,
    this.patient,
    required this.doctor,
    required this.status,
    this.pharmacist,
    required this.diagnostic,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  List<MedicineItem> medicineItems;
  dynamic patient;
  Doctor doctor;
  String status;
  dynamic pharmacist;
  String diagnostic;
  String note;
  DateTime createdAt;
  DateTime updatedAt;

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
        id: json["id"],
        medicineItems: List<MedicineItem>.from(
            json["medicine_items"].map((x) => MedicineItem.fromJson(x))),
        patient: json["patient"] != null
            ? UserInfo.fromJson(json["patient"])
            : json["patient"],
        doctor: Doctor.fromJson(json["doctor"]),
        status: json["status"],
        pharmacist: json["pharmacist"],
        diagnostic: json["diagnostic"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicine_items":
            List<dynamic>.from(medicineItems.map((x) => x.toJson())),
        "patient": patient?.toJson(),
        "doctor": doctor.toJson(),
        "status": status,
        "pharmacist": pharmacist,
        "diagnostic": diagnostic,
        "note": note,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
