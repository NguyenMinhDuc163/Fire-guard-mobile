import 'dart:convert';

SendNotificationRequest sendNotificationRequestFromJson(String str) =>
    SendNotificationRequest.fromJson(json.decode(str));

String sendNotificationRequestToJson(SendNotificationRequest data) =>
    json.encode(data.toJson());

class SendNotificationRequest {
  SendNotificationRequest({
    this.userId,
    this.message,
    this.timestamp,
  });

  final String? userId;
  final String? message;
  final DateTime? timestamp;

  factory SendNotificationRequest.fromJson(Map<String, dynamic> json) =>
      SendNotificationRequest(
        userId: json["user_id"],
        message: json["message"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "message": message,
    "timestamp": timestamp?.toIso8601String(),
  };
}
