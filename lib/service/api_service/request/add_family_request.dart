import 'dart:convert';

AddFamilyRequest addFamilyRequestFromJson(String str) =>
    AddFamilyRequest.fromJson(json.decode(str));

String addFamilyRequestToJson(AddFamilyRequest data) =>
    json.encode(data.toJson());

class AddFamilyRequest {
  AddFamilyRequest({
    required this.userId,
    required this.familyMemberId,
  });

  final int userId;
  final int familyMemberId;


  factory AddFamilyRequest.fromJson(Map<String, dynamic> json) =>
      AddFamilyRequest(
        userId: json["user_id"],
        familyMemberId: json["family_member_id"],
      );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "family_member_id": familyMemberId,
  };
}
