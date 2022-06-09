import 'base/medicine.dart';

class MedicineItems {
  MedicineItems({
    required this.id,
    required this.medicine,
    required this.amount,
    required this.note,
  });

  int id;
  Medicine medicine;
  int amount;
  String note;

  factory MedicineItems.fromJson(Map<String, dynamic> json) => MedicineItems(
        id: json["id"],
        medicine: Medicine.fromJson(json["medicine"]),
        amount: json["amount"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medicine": medicine.toJson(),
        "amount": amount,
        "note": note,
      };
}
