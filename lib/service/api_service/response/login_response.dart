import 'package:fire_guard/models/user.dart';

class LoginResponse {
  final String key;
  final dynamic value;

  LoginResponse({required this.key, required this.value});

  // Ánh xạ từ JSON sang LoginResponse
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      key: json['key'] as String,
      value: json['key'] == 'user'
          ? User.fromJson(json['value'])
          : json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value is User ? (value as User).toJson() : value,
    };
  }

  @override
  String toString() {
    return 'LoginResponse{key: $key, value: $value}';
  }
}
