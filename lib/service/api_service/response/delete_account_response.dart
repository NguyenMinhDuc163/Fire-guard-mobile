class DeleteAccountResponse {
  final int? id;
  final String? username;
  final String? email;
  final String? phoneNumber;
  final bool? isActive;
  final String? updatedAt;

  DeleteAccountResponse({
    this.id,
    this.username,
    this.email,
    this.phoneNumber,
    this.isActive,
    this.updatedAt,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      isActive: json["is_active"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "phone_number": phoneNumber,
        "is_active": isActive,
        "updated_at": updatedAt,
      };
}
