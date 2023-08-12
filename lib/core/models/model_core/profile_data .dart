// import 'package:intl/intl.dart' as intl;

class ProfileData {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? dateOfBirth;

  ProfileData({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "address": address,
      "city": city,
      "state": state,
      "zip": zip,
      "country": country,
      "dateOfBirth": dateOfBirth,
    };
  }
}
