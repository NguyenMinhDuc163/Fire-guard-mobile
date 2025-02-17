class GetFamilyResponse {
  final int? familyMemberId;
  final String? username;
  final String? phoneNumber;
  final String? tokenFcm;

  GetFamilyResponse({
    this.familyMemberId,
    this.username,
    this.phoneNumber,
    this.tokenFcm,
  });

  factory GetFamilyResponse.fromJson(Map<String, dynamic> json) {
    return GetFamilyResponse(
      familyMemberId: json["family_member_id"],
      username: json["username"],
      phoneNumber: json["phone_number"],
      tokenFcm: json["token_fcm"],
    );
  }

  Map<String, dynamic> toJson() => {
        "family_member_id": familyMemberId,
        "username": username,
        "phone_number": phoneNumber,
        "token_fcm": tokenFcm,
  };
}
