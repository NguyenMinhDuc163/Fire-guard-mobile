class UserModel {
  final int id;
  final String username;
  final String email;
  final String? isAdmin;
  final String? alertPhone;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isAdmin,
    required this.alertPhone,
    this.createdAt,
  });

  // Ánh xạ JSON sang User
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      isAdmin: json['is_admin'] as String?,
      createdAt: json['created_at'] as String?,
      alertPhone: json['alert_phone'] as String?,
    );
  }

  // Chuyển đối tượng User sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': createdAt,
      'is_admin': isAdmin,
      'alert_phone': alertPhone,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, createdAt: $createdAt isAdmin: $isAdmin}';
  }
}
