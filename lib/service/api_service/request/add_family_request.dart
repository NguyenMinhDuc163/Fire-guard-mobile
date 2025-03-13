import 'dart:convert';

AddFamilyRequest addFamilyRequestFromJson(String str) =>
    AddFamilyRequest.fromJson(json.decode(str));

String addFamilyRequestToJson(AddFamilyRequest data) =>
    json.encode(data.toJson());

class AddFamilyRequest {
  AddFamilyRequest({
     required this.ownerID,
     required this.email,
  });

  final int ownerID;
  final String email;


  factory AddFamilyRequest.fromJson(Map<String, dynamic> json) =>
      AddFamilyRequest(
        ownerID: json["user_id"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
    "user_id": ownerID,
    "email": email,
  };
}
