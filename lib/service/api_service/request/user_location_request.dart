  import 'dart:convert';

  UserLocationRequest userLocationRequestFromJson(String str) =>
      UserLocationRequest.fromJson(json.decode(str));

  String userLocationRequestToJson(UserLocationRequest data) =>
      json.encode(data.toJson());

  class UserLocationRequest {
    UserLocationRequest({
      required this.type,
      this.userID,
      this.longitude,
      this.latitude,
    });

    final String type;
    final int? userID;
    final String? longitude;
    final String? latitude;

    factory UserLocationRequest.fromJson(Map<String, dynamic> json) => UserLocationRequest(
      type: json["type"].toString(),
      userID: json["userID"],
      longitude: json["longitude"],
      latitude: json["latitude"],
    );

    Map<String, dynamic> toJson() => {
      "type": type,
      if (userID != null) "userID": userID,
      if (longitude != null) "longitude": longitude,
      if (latitude != null) "latitude": latitude,
    };
  }
