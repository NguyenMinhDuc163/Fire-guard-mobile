import 'dart:convert';

ForgotPasswordRequest forgotPasswordRequestFromJson(String str) =>
    ForgotPasswordRequest.fromJson(json.decode(str));

String forgotPasswordRequestToJson(ForgotPasswordRequest data) =>
    json.encode(data.toJson());

class ForgotPasswordRequest {
  ForgotPasswordRequest({
    required this.email,
  });

  final String email;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) => ForgotPasswordRequest(
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
  };
}
