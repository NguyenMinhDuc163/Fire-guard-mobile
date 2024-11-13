class UserListResponse {
  final int id;
  final String username;
  final String email;

  UserListResponse({
    required this.id,
    required this.username,
    required this.email,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) => UserListResponse(
    id: json["id"],
    username: json["username"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
  };
}
