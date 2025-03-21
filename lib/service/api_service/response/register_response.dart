import 'package:fire_guard/screens/authen_screen/models/user_model.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';

class RegisterResponse extends BaseResponse{
  final UserModel user;

  RegisterResponse({required this.user});

  // Ánh xạ JSON sang RegisterResponse
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      user: UserModel.fromJson(json),
    );
  }

  // Chuyển RegisterResponse sang JSON
  Map<String, dynamic> toJson() => user.toJson();

  @override
  String toString() {
    return 'RegisterResponse{user: $user}';
  }
}
