class UserModel {
  final String? id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String password;
  final String? aboutMe;
  final bool isVerified;
  final String? address;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.password,
    this.aboutMe,
    required this.isVerified,
    this.address,
  });

  toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "password": password,
      "about_me": aboutMe,
      "isVerified": isVerified,
      "address": address
    };
  }
}