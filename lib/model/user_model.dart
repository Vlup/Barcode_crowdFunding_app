class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String? aboutMe;
  final String? identityPath;
  final bool isVerified;
  final String? address;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    this.aboutMe,
    this.identityPath,
    required this.isVerified,
    this.address,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "password": password,
      "about_me": aboutMe,
      "identity_path": identityPath,
      "isVerified": isVerified,
      "address": address
    };
  }
}