import 'dart:convert';

FireEmergencyRequest fireEmergencyRequestFromJson(String str) =>
    FireEmergencyRequest.fromJson(json.decode(str));

String fireEmergencyRequestToJson(FireEmergencyRequest data) =>
    json.encode(data.toJson());

class FireEmergencyRequest {
  FireEmergencyRequest({
    this.location,
    this.incidentDetails,
    this.timestamp,
    this.phoneNumber,
  });

  final String? location;
  final String? incidentDetails;
  final String? phoneNumber;
  final DateTime? timestamp;

  factory FireEmergencyRequest.fromJson(Map<String, dynamic> json) =>
      FireEmergencyRequest(
        location: json["location"],
        incidentDetails: json["incident_details"],
        phoneNumber: json["phone_number"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "location": location,
    "incident_details": incidentDetails,
    "phone_number": phoneNumber,
    "timestamp": timestamp?.toIso8601String(),
  };
}
