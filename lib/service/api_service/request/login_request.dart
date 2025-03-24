import 'dart:convert';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) =>
    json.encode(data.toJson());

class LoginRequest {
  LoginRequest({
    required this.email,
    required this.password,
    required this.fcmToken,
  });

  final String email;
  final String password;
  final String fcmToken;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => LoginRequest(
    email: json["email"],
    password: json["password"],
    fcmToken: json["token_fcm"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "token_fcm": fcmToken,
  };
}
