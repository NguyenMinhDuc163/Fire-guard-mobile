import 'dart:convert';

SendNotificationRequest sendNotificationRequestFromJson(String str) =>
    SendNotificationRequest.fromJson(json.decode(str));

String sendNotificationRequestToJson(SendNotificationRequest data) =>
    json.encode(data.toJson());

class SendNotificationRequest {
  SendNotificationRequest({
    required this.familyMemberId,
    this.message,
    this.timestamp,
  });

  final int familyMemberId;
  final String? message;
  final DateTime? timestamp;

  factory SendNotificationRequest.fromJson(Map<String, dynamic> json) =>
      SendNotificationRequest(
        familyMemberId: json["familyMemberId"],
        message: json["message"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "familyMemberId": familyMemberId,
    "message": message,
    "timestamp": timestamp?.toIso8601String(),
  };
}
