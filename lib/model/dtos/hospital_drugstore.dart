import 'base/user_base.dart';

class HospitalDrugstore {
  HospitalDrugstore({
    required this.id,
    required this.user,
    this.background,
    required this.name,
    required this.address,
    required this.website,
    required this.description,
    required this.longitude,
    required this.latitude,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  User user;
  dynamic background;
  String name;
  String address;
  String website;
  String description;
  String longitude;
  String latitude;
  DateTime createdAt;
  DateTime updatedAt;

  factory HospitalDrugstore.fromJson(Map<String, dynamic> json) =>
      HospitalDrugstore(
        id: json["id"],
        user: User.fromJson(json["user"]),
        background: json["background"],
        name: json["name"],
        address: json["address"],
        website: json["website"],
        description: json["description"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "background": background,
        "name": name,
        "address": address,
        "website": website,
        "description": description,
        "longitude": longitude,
        "latitude": latitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
