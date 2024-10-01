
import 'dart:convert';

AuthenticationRequest authenticationRequestFromJson(String str) => AuthenticationRequest.fromJson(json.decode(str));

String authenticationRequestToJson(AuthenticationRequest data) => json.encode(data.toJson());

class AuthenticationRequest {
  AuthenticationRequest({
    this.username,
    this.password,
    this.deviceId,
    this.tokenId,
    this.operatingSystem,
    this.passCode,
    this.lang,
  });

  final String? username;
  final String? password;
  final String? deviceId;
  final String? tokenId;
  final String? operatingSystem;
  final String? passCode;
  final String? lang;

  factory AuthenticationRequest.fromJson(Map<String, dynamic> json) => AuthenticationRequest(
    username: json["username"] == null ? null : json["username"],
    password: json["password"] == null ? null : json["password"],
    deviceId: json["deviceId"] == null ? null : json["deviceId"],
    tokenId: json["tokenId"] == null ? null : json["tokenId"],
    operatingSystem: json["operatingSystem"] == null ? null : json["operatingSystem"],
    passCode: json["passCode"] == null ? null : json["passCode"],
    lang: json["lang"] == null ? null : json["lang"],
  );

  Map<String, dynamic> toJson() => {
    "username": username == null ? null : username,
    "password": password == null ? null : password,
    "deviceId": deviceId == null ? null : deviceId,
    "tokenId": tokenId == null ? null : tokenId,
    "operatingSystem": operatingSystem == null ? null : operatingSystem,
    "passCode": passCode == null ? null : passCode,
    "lang": lang == null ? null : lang,
  };
}
