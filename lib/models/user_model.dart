class UserModel {
  final String username;
  final String password;
  final String email;
  final String fullName;

  UserModel({
    required this.username,
    required this.password,
    required this.email,
    required this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'fullName': fullName,
    };
  }
}

