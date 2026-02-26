class UserRegistration {
  String? name;
  String? gender;
  int? age;
  String? country;
  String? phone;

  String? photoCID;

  String? summary;
  List<String>? interests;
  List<Map<String, String>>? emergencyContacts;

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "gender": gender,
      "age": age,
      "country": country,
      "phone": phone,
      "photo": photoCID,
      "summary": summary,
      "interests": interests,
      "emergencyContacts": emergencyContacts,
    };
  }
}
