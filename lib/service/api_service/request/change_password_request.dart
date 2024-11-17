import 'dart:convert';

ChangePasswordRequest changePasswordRequestFromJson(String str) =>
    ChangePasswordRequest.fromJson(json.decode(str));

String changePasswordRequestToJson(ChangePasswordRequest data) =>
    json.encode(data.toJson());

class ChangePasswordRequest {
  ChangePasswordRequest({
    required this.userID,
    this.oldPassword,
    this.newPassword,
  });

  final int userID;
  final String? oldPassword;
  final String? newPassword;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => ChangePasswordRequest(
    userID: json["id"],
    oldPassword: json["oldPassword"],
    newPassword: json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "id": userID,
    if (oldPassword != null) "oldPassword": oldPassword,
    if (newPassword != null) "newPassword": newPassword,
  };
}
