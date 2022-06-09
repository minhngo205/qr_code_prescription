import 'base/user_base.dart';

class Hospital {
  Hospital({
    required this.id,
    required this.user,
    required this.name,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  User user;
  String name;
  String address;
  DateTime createdAt;
  DateTime updatedAt;

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        id: json["id"],
        user: User.fromJson(json["user"]),
        name: json["name"],
        address: json["address"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "name": name,
        "address": address,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
