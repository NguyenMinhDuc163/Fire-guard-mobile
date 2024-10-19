import 'dart:convert';

SendDataSensorResponse sendDataSensorResponseFromJson(String str) =>
    SendDataSensorResponse.fromJson(json.decode(str));

String sendDataSensorResponseToJson(SendDataSensorResponse data) =>
    json.encode(data.toJson());

class SendDataSensorResponse {
  SendDataSensorResponse({
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

  factory SendDataSensorResponse.fromJson(Map<String, dynamic> json) =>
      SendDataSensorResponse(
        code: json["code"] == null ? null : json["code"],
        data: json["data"] == null ? null : List<dynamic>.from(json["data"]),
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        error: json["error"] == null ? null : json["error"],
      );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "data": data == null ? null : List<dynamic>.from(data!),
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "error": error == null ? null : error,
  };
}
