import 'dart:convert';

SendNotificationResponse sendNotificationResponseFromJson(String str) =>
    SendNotificationResponse.fromJson(json.decode(str));

String sendNotificationResponseToJson(SendNotificationResponse data) => json.encode(data.toJson());

class SendNotificationResponse {
  SendNotificationResponse();

  factory SendNotificationResponse.fromJson(Map<String, dynamic> json) =>
      SendNotificationResponse();

  Map<String, dynamic> toJson() => {};
}
