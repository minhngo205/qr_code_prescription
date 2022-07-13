import 'doctor.dart';
import 'medicine_item.dart';
import 'base/medical_infor.dart';

class PrescriptionItem {
  PrescriptionItem({
    required this.id,
    required this.medicineItems,
    required this.doctor,
    required this.status,
    required this.medicalInfo,
    required this.diagnostic,
    required this.doctorNote,
    required this.pharmacistNote,
    required this.createdAt,
    required this.updatedAt,
    this.pharmacist,
  });

  int id;
  List<MedicineItem> medicineItems;
  Doctor doctor;
  String status;
  MedicalInfo medicalInfo;
  String diagnostic;
  String doctorNote;
  String pharmacistNote;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic pharmacist;

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) => PrescriptionItem(
    id: json["id"],
    medicineItems: List<MedicineItem>.from(json["medicine_items"].map((x) => MedicineItem.fromJson(x))),
    doctor: Doctor.fromJson(json["doctor"]),
    status: json["status"],
    medicalInfo: MedicalInfo.fromJson(json["medical_info"]),
    diagnostic: json["diagnostic"],
    doctorNote: json["doctor_note"],
    pharmacistNote: json["pharmacist_note"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pharmacist: json["pharmacist"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "medicine_items": List<dynamic>.from(medicineItems.map((x) => x.toJson())),
    "doctor": doctor.toJson(),
    "status": status,
    "medical_info": medicalInfo.toJson(),
    "diagnostic": diagnostic,
    "doctor_note": doctorNote,
    "pharmacist_note": pharmacistNote,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "pharmacist": pharmacist,
  };
}