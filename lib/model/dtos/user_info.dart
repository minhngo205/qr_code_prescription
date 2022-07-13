import 'base/medical_infor.dart';
import 'base/user_base.dart';

class UserInfo {
  UserInfo({
    required this.id,
    required this.user,
    required this.dob,
    required this.medicalInfo,
    required this.name,
    required this.gender,
    required this.address,
    required this.identifyNumber,
    required this.socialInsurance,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  User user;
  DateTime dob;
  MedicalInfo medicalInfo;
  String name;
  bool gender;
  String address;
  String identifyNumber;
  String socialInsurance;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        user: User.fromJson(json["user"]),
        dob: DateTime.parse(json["dob"]),
        medicalInfo: MedicalInfo.fromJson(json["medical_info"]),
        name: json["name"],
        gender: json["gender"],
        address: json["address"],
        identifyNumber: json["identify_number"],
        socialInsurance: json["social_insurance"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "medical_info": medicalInfo.toJson(),
        "name": name,
        "gender": gender,
        "address": address,
        "identify_number": identifyNumber,
        "social_insurance": socialInsurance,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
