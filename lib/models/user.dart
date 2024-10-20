class User {
  final int id;
  final String username;
  final String email;
  final String? createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.createdAt,
  });

  // Ánh xạ JSON sang User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      createdAt: json['created_at'] as String?,
    );
  }

  // Chuyển đối tượng User sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, createdAt: $createdAt}';
  }
}
