import 'dart:convert';

SaveDeviceStatusResponse saveDeviceStatusResponseFromJson(String str) =>
    SaveDeviceStatusResponse.fromJson(json.decode(str));

String saveDeviceStatusResponseToJson(SaveDeviceStatusResponse data) =>
    json.encode(data.toJson());

class SaveDeviceStatusResponse {
  SaveDeviceStatusResponse();

  factory SaveDeviceStatusResponse.fromJson(Map<String, dynamic> json) =>
      SaveDeviceStatusResponse();

  Map<String, dynamic> toJson() => {};
}
