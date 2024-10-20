import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  RegisterRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.tokenFcm,
  });

  final String username;
  final String email;
  final String password;
  final String tokenFcm;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        username: json["username"],
        email: json["email"],
        password: json["password"],
        tokenFcm: json["token_fcm"],
      );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "password": password,
    "token_fcm": tokenFcm,
  };
}
