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
    this.familyMemberId,
  });

  final String? location;
  final String? incidentDetails;
  final String? phoneNumber;
  final int? familyMemberId;
  final DateTime? timestamp;

  factory FireEmergencyRequest.fromJson(Map<String, dynamic> json) =>
      FireEmergencyRequest(
        location: json["location"],
        incidentDetails: json["incident_details"],
        phoneNumber: json["phone_number"],
        familyMemberId: json["family_member_id"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
    "location": location,
    "incident_details": incidentDetails,
    "phone_number": phoneNumber,
    "family_member_id": familyMemberId,
    "timestamp": timestamp?.toIso8601String(),
  };
}
