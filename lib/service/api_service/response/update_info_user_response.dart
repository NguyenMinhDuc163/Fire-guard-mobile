class UpdateInfoUserResponse {
  final int? id;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final String? clickSendName;
  final String? updatedAt;
  final String? clickSendKey;

  UpdateInfoUserResponse({
    this.id,
    this.username,
    this.email,
    this.phoneNumber,
    this.clickSendName,
    this.clickSendKey,
    this.updatedAt,
  });

  factory UpdateInfoUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateInfoUserResponse(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      clickSendName: json["click_send_name"],
      updatedAt: json["updated_at"],
      clickSendKey: json["click_send_key"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "click_send_name": clickSendName,
        "updated_at": updatedAt,
        "click_send_key": clickSendKey,
      };

  @override
  String toString() {
    return 'UpdateInfoUserResponse{id: $id, username: $username, email: $email, phone_number: $phoneNumber, click_send_name: $clickSendName, updated_at: $updatedAt, click_send_key: $clickSendKey}';
  }
}
