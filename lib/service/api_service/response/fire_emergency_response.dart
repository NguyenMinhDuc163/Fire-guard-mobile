import 'dart:convert';

FireEmergencyResponse fireEmergencyResponseFromJson(String str) =>
    FireEmergencyResponse.fromJson(json.decode(str));

String fireEmergencyResponseToJson(FireEmergencyResponse data) =>
    json.encode(data.toJson());

class FireEmergencyResponse {
  FireEmergencyResponse();

  factory FireEmergencyResponse.fromJson(Map<String, dynamic> json) =>
      FireEmergencyResponse();

  Map<String, dynamic> toJson() => {};
}
