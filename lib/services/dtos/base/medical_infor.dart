class MedicalInfo {
  MedicalInfo({
    required this.id,
    required this.height,
    required this.weight,
    required this.bodyTemperature,
    required this.systolicBloodPressure,
    required this.diastolicBloodPressure,
    required this.bloodGroup,
    required this.medicalHistory,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int height;
  int weight;
  double bodyTemperature;
  int systolicBloodPressure;
  int diastolicBloodPressure;
  String bloodGroup;
  String medicalHistory;
  DateTime createdAt;
  DateTime updatedAt;

  factory MedicalInfo.fromJson(Map<String, dynamic> json) => MedicalInfo(
        id: json["id"],
        height: json["height"],
        weight: json["weight"],
        bodyTemperature: json["body_temperature"],
        systolicBloodPressure: json["systolic_blood_pressure"],
        diastolicBloodPressure: json["diastolic_blood_pressure"],
        bloodGroup: json["blood_group"],
        medicalHistory: json["medical_history"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "height": height,
        "weight": weight,
        "body_temperature": bodyTemperature,
        "systolic_blood_pressure": systolicBloodPressure,
        "diastolic_blood_pressure": diastolicBloodPressure,
        "blood_group": bloodGroup,
        "medical_history": medicalHistory,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
