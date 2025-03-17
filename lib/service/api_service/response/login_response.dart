import 'package:fire_guard/screens/authen_screen/models/user_model.dart';

class LoginResponse {
  final String key;
  final dynamic value;

  LoginResponse({required this.key, required this.value});

  // Ánh xạ từ JSON sang LoginResponse
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      key: json['key'] as String,
      value: json['key'] == 'UserModel'
          ? UserModel.fromJson(json['value'])
          : json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value is UserModel ? (value as UserModel).toJson() : value,
    };
  }

  @override
  String toString() {
    return 'LoginResponse{key: $key, value: $value}';
  }
}
