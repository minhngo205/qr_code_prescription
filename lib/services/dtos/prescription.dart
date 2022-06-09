import 'medicine_list.dart';
import 'doctor.dart';

class Prescription {
  int id;
  List<MedicineItems> medicineItems;
  Doctor doctor;
  String status;
  String diagnostic;
  DateTime createdAt;
  DateTime updatedAt;
  int pharmacist;

  Prescription(
      {required this.id,
      required this.medicineItems,
      required this.doctor,
      required this.status,
      required this.pharmacist,
      required this.diagnostic,
      required this.createdAt,
      required this.updatedAt});

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
        id: json["id"],
        medicineItems: List<MedicineItems>.from(
            json["medicine_items"].map((x) => MedicineItems.fromJson(x))),
        doctor: Doctor.fromJson(json["doctor"]),
        status: json["status"],
        diagnostic: json["diagnostic"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        pharmacist: json["pharmacist"] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicine_items":
            List<dynamic>.from(medicineItems.map((x) => x.toJson())),
        "doctor": doctor.toJson(),
        "status": status,
        "diagnostic": diagnostic,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "pharmacist": pharmacist,
      };
}
