import 'dart:convert';

List<SaveDeviceStatusRequest> saveDeviceStatusRequestFromJson(String str) =>
    List<SaveDeviceStatusRequest>.from(
        json.decode(str).map((x) => SaveDeviceStatusRequest.fromJson(x)));

String saveDeviceStatusRequestToJson(List<SaveDeviceStatusRequest> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SaveDeviceStatusRequest {
  SaveDeviceStatusRequest({
    this.deviceName,
    this.status,
    this.timestamp,
  });

  final String? deviceName;
  final String? status;
  final DateTime? timestamp;

  factory SaveDeviceStatusRequest.fromJson(Map<String, dynamic> json) =>
      SaveDeviceStatusRequest(
        deviceName: json["device_name"],
        status: json["status"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "device_name": deviceName,
    "status": status,
    "timestamp": timestamp?.toIso8601String(),
  };
}
