class LoginResponse {
  final String token;
  final String role;
  final String name;
  final String email;

  LoginResponse({required this.token, required this.role, required this.name, required this.email});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      role: json['role'],
      name: json['name'],
      email: json['email'],
    );
  }
}