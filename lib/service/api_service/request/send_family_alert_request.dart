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
    this.phoneNumber,
  });

  final String? userId;
  final String? familyMemberId;
  final String? message;
  final DateTime? timestamp;
  final String? phoneNumber;

  factory SendFamilyAlertRequest.fromJson(Map<String, dynamic> json) =>
      SendFamilyAlertRequest(
        userId: json["user_id"],
        familyMemberId: json["family_member_id"],
        message: json["message"],
        phoneNumber: json["phone_number"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "family_member_id": familyMemberId,
    "message": message,
    "phone_number": phoneNumber,
    "timestamp": timestamp?.toIso8601String(),
  };
}
