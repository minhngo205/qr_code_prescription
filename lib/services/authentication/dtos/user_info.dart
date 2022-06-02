class UserInfo {
  int? id;
  String? username;
  String? email;
  String? role;
  String? name;
  String? address;
  String? phoneNumber;
  String? dob;
  String? createdAt;
  String? updatedAt;

  UserInfo(
      {this.id,
      this.username,
      this.email,
      this.role,
      this.name,
      this.address,
      this.phoneNumber,
      this.dob,
      this.createdAt,
      this.updatedAt});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    role = json['role'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    dob = json['dob'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['role'] = role;
    data['name'] = name;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['dob'] = dob;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
