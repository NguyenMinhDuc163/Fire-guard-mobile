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
     this.tokenFcm,
     this.phoneNumber,
     this.clickSendName,
     this.clickSendKey,
  });

  final String username;
  final String email;
  final String password;
  final String? tokenFcm;
  final String? phoneNumber;
  final String? clickSendName;
  final String? clickSendKey;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        username: json["username"],
        email: json["email"],
        password: json["password"],
        tokenFcm: json["token_fcm"],
        phoneNumber: json["phone_number"],
        clickSendName: json["click_send_name"],
        clickSendKey: json["token_fcm"],
      );

  Map<String, dynamic> toJson() => {
    "username": username,
    "email": email,
    "password": password,
    "token_fcm": tokenFcm,
    "click_send_name": clickSendName,
    "phone_number": phoneNumber,
    "click_send_key": clickSendKey,
  };
}
