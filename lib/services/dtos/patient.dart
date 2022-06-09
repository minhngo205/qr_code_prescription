import 'base/medical_infor.dart';
import 'base/user_base.dart';

class Patient {
  int? id;
  User? user;
  String? dob;
  MedicalInfo? medicalInfo;
  String? name;
  bool? gender;
  String? identifyNumber;
  String? socialInsurance;
  String? createdAt;
  String? updatedAt;

  Patient(
      {this.id,
      this.user,
      this.dob,
      this.medicalInfo,
      this.name,
      this.gender,
      this.identifyNumber,
      this.socialInsurance,
      this.createdAt,
      this.updatedAt});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    dob = json['dob'];
    medicalInfo = json['medical_info'];
    name = json['name'];
    gender = json['gender'];
    identifyNumber = json['identify_number'];
    socialInsurance = json['social_insurance'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['dob'] = dob;
    data['medical_info'] = medicalInfo;
    data['name'] = name;
    data['gender'] = gender;
    data['identify_number'] = identifyNumber;
    data['social_insurance'] = socialInsurance;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
