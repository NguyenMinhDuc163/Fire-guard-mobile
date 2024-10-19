import 'dart:convert';

SendNotificationResponse sendNotificationResponseFromJson(String str) =>
    SendNotificationResponse.fromJson(json.decode(str));

String sendNotificationResponseToJson(SendNotificationResponse data) =>
    json.encode(data.toJson());

class SendNotificationResponse {
  SendNotificationResponse({
    this.code,
    this.data,
    this.status,
    this.message,
    this.error,
  });

  final int? code;
  final List<dynamic>? data;
  final String? status;
  final String? message;
  final String? error;

  factory SendNotificationResponse.fromJson(Map<String, dynamic> json) =>
      SendNotificationResponse(
        code: json["code"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
        status: json["status"],
        message: json["message"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "data": List<dynamic>.from(data!.map((x) => x)),
    "status": status,
    "message": message,
    "error": error,
  };
}
