import 'base/medicine.dart';

class MedicineItem {
  MedicineItem({
    required this.id,
    required this.medicine,
    required this.amount,
    required this.doctorNote,
    required this.pharmacistNote,
  });

  int id;
  Medicine medicine;
  int amount;
  String doctorNote;
  String pharmacistNote;

  factory MedicineItem.fromJson(Map<String, dynamic> json) => MedicineItem(
        id: json["id"],
        medicine: Medicine.fromJson(json["medicine"]),
        amount: json["amount"],
        doctorNote: json["doctor_note"],
        pharmacistNote: json["pharmacist_note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicine": medicine.toJson(),
        "amount": amount,
        "doctor_note": doctorNote,
        "pharmacist_note": pharmacistNote,
      };
}
