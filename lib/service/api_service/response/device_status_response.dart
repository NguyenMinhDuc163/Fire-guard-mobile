class DeviceStatusResponse {
  final String deviceName;
  final String status;

  DeviceStatusResponse({
    required this.deviceName,
    required this.status,
  });

  factory DeviceStatusResponse.fromJson(Map<String, dynamic> json) {
    return DeviceStatusResponse(
      deviceName: json['device_name'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "device_name": deviceName,
    "status": status,
  };

  @override
  String toString() {
    return 'DeviceStatusResponse{deviceName: $deviceName, status: $status}';
  }
}
