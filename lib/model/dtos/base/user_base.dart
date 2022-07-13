class User {
  User({
    required this.id,
    required this.phoneNumber,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  int id;
  String phoneNumber;
  String email;
  String role;
  DateTime createdAt;
  DateTime updatedAt;
  bool isActive;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phone_number": phoneNumber,
        "email": email,
        "role": role,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_active": isActive,
      };
}
