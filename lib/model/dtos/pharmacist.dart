import 'package:qr_code_prescription/model/dtos/hospital_drugstore.dart';

import 'base/user_base.dart';

class Pharmacist {
  Pharmacist({
    required this.id,
    required this.user,
    required this.drugstore,
    required this.name,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  User user;
  HospitalDrugstore drugstore;
  String name;
  bool gender;
  DateTime createdAt;
  DateTime updatedAt;

  factory Pharmacist.fromJson(Map<String, dynamic> json) => Pharmacist(
    id: json["id"],
    user: User.fromJson(json["user"]),
    drugstore: HospitalDrugstore.fromJson(json["drugstore"]),
    name: json["name"],
    gender: json["gender"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "drugstore": drugstore.toJson(),
    "name": name,
    "gender": gender,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
