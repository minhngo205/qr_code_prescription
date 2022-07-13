import 'base/user_base.dart';
import 'hospital_drugstore.dart';

class Doctor {
  Doctor({
    required this.id,
    required this.user,
    required this.hospital,
    required this.name,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  User user;
  HospitalDrugstore hospital;
  String name;
  bool gender;
  DateTime createdAt;
  DateTime updatedAt;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        user: User.fromJson(json["user"]),
        hospital: HospitalDrugstore.fromJson(json["hospital"]),
        name: json["name"],
        gender: json["gender"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "hospital": hospital.toJson(),
        "name": name,
        "gender": gender,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
