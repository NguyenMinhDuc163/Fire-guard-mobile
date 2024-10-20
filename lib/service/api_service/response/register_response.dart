import 'package:fire_guard/models/user.dart';

class RegisterResponse {
  final User user;

  RegisterResponse({required this.user});

  // Ánh xạ JSON sang RegisterResponse
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: User.fromJson(json),
    );
  }

  // Chuyển RegisterResponse sang JSON
  Map<String, dynamic> toJson() => user.toJson();

  @override
  String toString() {
    return 'RegisterResponse{user: $user}';
  }
}
