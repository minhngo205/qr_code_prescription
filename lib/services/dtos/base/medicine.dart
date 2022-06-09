class Medicine {
  Medicine({
    required this.id,
    required this.name,
    required this.tradeName,
    required this.concentration,
    required this.usage,
    required this.hospitalGrade,
    required this.note,
    required this.facility,
    required this.country,
  });

  int id;
  String name;
  String tradeName;
  String concentration;
  String usage;
  String hospitalGrade;
  String note;
  String facility;
  String country;

  factory Medicine.fromJson(Map<String, dynamic> json) => Medicine(
        id: json["id"],
        name: json["name"],
        tradeName: json["trade_name"],
        concentration: json["concentration"],
        usage: json["usage"],
        hospitalGrade: json["hospital_grade"],
        note: json["note"],
        facility: json["facility"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "trade_name": tradeName,
        "concentration": concentration,
        "usage": usage,
        "hospital_grade": hospitalGrade,
        "note": note,
        "facility": facility,
        "country": country,
      };
}
