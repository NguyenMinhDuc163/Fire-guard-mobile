import 'dart:convert';

SaveDeviceStatusResponse saveDeviceStatusResponseFromJson(String str) =>
    SaveDeviceStatusResponse.fromJson(json.decode(str));

String saveDeviceStatusResponseToJson(SaveDeviceStatusResponse data) => json.encode(data.toJson());

class SaveDeviceStatusResponse {
  final String deviceName;
  final String status;
  final String timestamp;

  SaveDeviceStatusResponse({
    required this.deviceName,
    required this.status,
    required this.timestamp,
  });

  factory SaveDeviceStatusResponse.fromJson(Map<String, dynamic> json) => SaveDeviceStatusResponse(
        deviceName: json['device_name'] as String,
        status: json['status'] as String,
        timestamp: json['timestamp'] as String,
      );

  Map<String, dynamic> toJson() => {
        "device_name": deviceName,
        "status": status,
        "timestamp": timestamp,
      };

  @override
  String toString() {
    return 'SaveDeviceStatusResponse{deviceName: $deviceName, status: $status, timestamp: $timestamp}';
  }
}
