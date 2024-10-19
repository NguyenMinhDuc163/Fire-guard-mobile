import 'dart:convert';

SendFamilyAlertRequest sendFamilyAlertRequestFromJson(String str) =>
    SendFamilyAlertRequest.fromJson(json.decode(str));

String sendFamilyAlertRequestToJson(SendFamilyAlertRequest data) =>
    json.encode(data.toJson());

class SendFamilyAlertRequest {
  SendFamilyAlertRequest({
    this.userId,
    this.familyMemberId,
    this.message,
    this.timestamp,
  });

  final String? userId;
  final String? familyMemberId;
  final String? message;
  final DateTime? timestamp;

  factory SendFamilyAlertRequest.fromJson(Map<String, dynamic> json) =>
      SendFamilyAlertRequest(
        userId: json["user_id"],
        familyMemberId: json["family_member_id"],
        message: json["message"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "family_member_id": familyMemberId,
    "message": message,
    "timestamp": timestamp?.toIso8601String(),
  };
}
