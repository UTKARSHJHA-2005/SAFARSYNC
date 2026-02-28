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
      if (name != null) "name": name,
      if (gender != null) "gender": gender,
      if (age != null) "age": age,
      if (country != null) "country": country,
      if (phone != null) "phone": phone,
      if (photoCID != null) "photo": photoCID,
      if (summary != null) "summary": summary,
      if (interests != null) "interests": interests,
      if (emergencyContacts != null) "emergencyContacts": emergencyContacts,
    };
  }
}
