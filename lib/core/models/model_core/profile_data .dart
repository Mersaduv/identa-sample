import 'package:intl/intl.dart' as intl;

class ProfileData {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final DateTime? selectedDate;
  final String zipCode;
  final String state;
  final String address;
  final String city;
  final String selectedLocation;

  ProfileData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    this.selectedDate,
    required this.zipCode,
    required this.state,
    required this.address,
    required this.city,
    required this.selectedLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phoneNumber,
      "address": address,
      "city": city,
      "state": state,
      "zip": zipCode,
      "country": selectedLocation,
      "dateOfBirth": selectedDate != null
          ? intl.DateFormat('yyyy-MM-dd').format(selectedDate!)
          : '',
    };
  }
}
