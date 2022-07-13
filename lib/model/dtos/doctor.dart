import 'base/user_base.dart';
import 'hospital_drugstore.dart';

class Doctor {
  Doctor({
    required this.id,
    required this.user,
    required this.hospital,
    required this.avatar,
    required this.name,
    required this.gender,
    required this.department,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  User user;
  HospitalDrugstore hospital;
  String avatar;
  String name;
  bool gender;
  String department;
  DateTime createdAt;
  DateTime updatedAt;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        user: User.fromJson(json["user"]),
        hospital: HospitalDrugstore.fromJson(json["hospital"]),
        avatar: json["avatar"],
        name: json["name"],
        gender: json["gender"],
        department: json["department"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "hospital": hospital.toJson(),
        "avatar": avatar,
        "name": name,
        "gender": gender,
        "department": department,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
