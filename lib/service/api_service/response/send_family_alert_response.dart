import 'dart:convert';

SendFamilyAlertResponse sendFamilyAlertResponseFromJson(String str) =>
    SendFamilyAlertResponse.fromJson(json.decode(str));

String sendFamilyAlertResponseToJson(SendFamilyAlertResponse data) =>
    json.encode(data.toJson());

class SendFamilyAlertResponse {
  SendFamilyAlertResponse();

  factory SendFamilyAlertResponse.fromJson(Map<String, dynamic> json) =>
      SendFamilyAlertResponse();

  Map<String, dynamic> toJson() => {};
}
