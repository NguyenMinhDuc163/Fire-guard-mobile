import 'dart:convert';

UpdateInfoUserRequest updateInfoUserRequestFromJson(String str) =>
    UpdateInfoUserRequest.fromJson(json.decode(str));

String updateInfoUserRequestToJson(UpdateInfoUserRequest data) =>
    json.encode(data.toJson());

class UpdateInfoUserRequest {
  UpdateInfoUserRequest({
    required this.id,
    this.email,
    this.phoneNumber,
    this.clickSendName,
    this.clickSendKey,
  });

  final int id;
  final String? email;
  final String? phoneNumber;
  final String? clickSendName;
  final String? clickSendKey;

  factory UpdateInfoUserRequest.fromJson(Map<String, dynamic> json) =>
      UpdateInfoUserRequest(
        id: json["id"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        clickSendName: json["click_send_name"],
        clickSendKey: json["token_fcm"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "click_send_name": clickSendName,
    "phone_number": phoneNumber,
    "click_send_key": clickSendKey,
  };
}
