import 'base/medicine.dart';

class MedicineItem {
  MedicineItem({
    required this.id,
    required this.medicine,
    required this.amount,
    required this.doctorNote,
  });

  int id;
  Medicine medicine;
  int amount;
  String doctorNote;

  factory MedicineItem.fromJson(Map<String, dynamic> json) => MedicineItem(
        id: json["id"],
        medicine: Medicine.fromJson(json["medicine"]),
        amount: json["amount"],
        doctorNote: json["doctor_note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicine": medicine.toJson(),
        "amount": amount,
        "doctor_note": doctorNote,
      };
}
