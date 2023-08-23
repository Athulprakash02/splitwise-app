class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final int phoneNumber;
  final String userType;

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.userType,
  });

  toJson() {
    return {
      'full name': fullName,
      'email': email,
      'phone number': phoneNumber,
      'User type': userType,
    };
  }
}
