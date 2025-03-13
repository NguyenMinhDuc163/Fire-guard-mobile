import 'dart:convert';

DeleteFamilyRequest DeleteFamilyRequestFromJson(String str) =>
    DeleteFamilyRequest.fromJson(json.decode(str));

String DeleteFamilyRequestToJson(DeleteFamilyRequest data) =>
    json.encode(data.toJson());

class DeleteFamilyRequest {
  DeleteFamilyRequest({
    required this.ownerID,
    required this.familyMemberId,
  });

  final int ownerID;
  final int familyMemberId;


  factory DeleteFamilyRequest.fromJson(Map<String, dynamic> json) =>
      DeleteFamilyRequest(
        ownerID: json["user_id"],
        familyMemberId: json["family_member_id"],
      );

  Map<String, dynamic> toJson() => {
    "user_id": ownerID,
    "family_member_id": familyMemberId,
  };
}
