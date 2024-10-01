import 'package:fire_guard/models/user_model.dart';
import 'package:fire_guard/service/auth_services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthWithSupabase implements AuthService {
  UserModel? _user;

  UserModel? get user => _user;
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<UserModel?> signInWithEmailAndPassWord(
      {required String email,
      required String password,
      String? userName = 'nguyen duc',
      String? phoneNum = '0123456'}) async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        _user = UserModel(id: response.session!.user.id, email: response.session!.user.email!);
      } else {
        throw Exception('Sign In Failed');
      }
    } catch (e) {
      throw Exception('Sign In Failed: $e');
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      _user = null;
    } catch (e) {
      throw Exception('Sign Out Failed: $e');
    }
  }

  @override
  Future<UserModel?> signUpWithEmailAndPassWord(
      {required String email, required String password, String? userName, String? phoneNum}) async {
    try {
      final authResponse = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.user != null) {
        // Đăng ký thành công, xử lý tiếp ở đây
        print('Đăng ký thành công!');
      } else {
        // Đăng ký thất bại, hiển thị thông báo lỗi
        print('Đăng ký thất bại: ');
      }
    } catch (e) {
      throw Exception('Sign Up Failed: $e');
    }
    return null;
  }
}
