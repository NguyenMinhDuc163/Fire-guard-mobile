import 'package:fire_guard/models/user_model.dart';

abstract class AuthService {
  Future<UserModel?> signUpWithEmailAndPassWord({
    required String email,
    required String password,
    String? userName,
    String? phoneNum,
  });

  Future<UserModel?> signInWithEmailAndPassWord({
    required String email,
    required String password,
  });

  Future<void> signOut();

}