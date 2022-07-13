import 'user_info.dart';
import 'base/medical_infor.dart';
import 'medicine_item.dart';
import 'doctor.dart';
import 'pharmacist.dart';

class Prescription {
  Prescription({
    required this.id,
    required this.medicineItems,
    required this.patient,
    required this.doctor,
    required this.status,
    this.pharmacist,
    required this.medicalInfo,
    required this.diagnostic,
    required this.doctorNote,
    required this.pharmacistNote,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  List<MedicineItem> medicineItems;
  UserInfo patient; //
  Doctor doctor;
  String status;
  Pharmacist? pharmacist; //
  MedicalInfo medicalInfo;
  String diagnostic;
  String doctorNote;
  String pharmacistNote;
  DateTime createdAt;
  DateTime updatedAt;

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
        id: json["id"],
        medicineItems: List<MedicineItem>.from(
            json["medicine_items"].map((x) => MedicineItem.fromJson(x))),
        patient: UserInfo.fromJson(json["patient"]),
        doctor: Doctor.fromJson(json["doctor"]),
        status: json["status"],
        pharmacist: json["pharmacist"] != null
            ? Pharmacist.fromJson(json["pharmacist"])
            : null,
        medicalInfo: MedicalInfo.fromJson(json["medical_info"]),
        diagnostic: json["diagnostic"],
        doctorNote: json["doctor_note"],
        pharmacistNote: json["pharmacist_note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicine_items":
            List<dynamic>.from(medicineItems.map((x) => x.toJson())),
        "patient": patient.toJson(),
        "doctor": doctor.toJson(),
        "status": status,
        "pharmacist": pharmacist!.toJson(),
        "medical_info": medicalInfo.toJson(),
        "diagnostic": diagnostic,
        "doctor_note": doctorNote,
        "pharmacist_note": pharmacistNote,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
