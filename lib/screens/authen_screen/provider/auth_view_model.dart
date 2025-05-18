import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/authen_screen/models/auth_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/forgot_password_request.dart';
import 'package:fire_guard/service/api_service/request/login_request.dart';
import 'package:fire_guard/service/api_service/request/register_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/forgot_password_response.dart';
import 'package:fire_guard/service/api_service/response/login_response.dart';
import 'package:fire_guard/service/api_service/response/register_response.dart';
import 'package:fire_guard/service/service_config/network_service.dart';
import 'package:fire_guard/utils/core/common/toast.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../providers/BaseViewModel.dart';

class AuthViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  AuthModel authModel = AuthModel();
  AuthModel get model => authModel;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<bool> signIn({required String username, required String password}) async {
    return await execute(() async{
      final tokenFCM = LocalStorageHelper.getValue('fcm_token');
      LoginRequest request = LoginRequest(
        email: username,
        password: password,
        fcmToken: tokenFCM ?? "123",
      );
      final BaseResponse<LoginResponse> response = await apiServices.sendLogin(request);

      if (response.code != null) {
        for (var item in response.data!) {
          if (item.key == 'token'){
            await LocalStorageHelper.setValue("authToken", item.value);
            String newToken = LocalStorageHelper.getValue("authToken");
            NetworkService.instance.updateAuthToken(newToken);
          }

          if (item.key == 'user' && item.value is Map<String, dynamic>) {
            Map<String, dynamic> userMap = item.value as Map<String, dynamic>;
            LocalStorageHelper.setValue("userName", userMap['username']);
            LocalStorageHelper.setValue("email", userMap['email']);
            LocalStorageHelper.setValue("userId", userMap['id']);
            LocalStorageHelper.setValue("isAdmin", userMap["is_admin"]);
            LocalStorageHelper.setValue("alertPhone", userMap["alert_phone"]);
            break; // Dừng vòng lặp khi tìm thấy user
          }
        }
      }
      notifyListeners();

      if (response.code == 200 || response.code == 201) {
        showToastTop(
          message: response.message.toString(),
        );
        return true;
      } else {
        showToastTop(
          message: "auth.login_failed".tr(),
        );
        return false;
      }
    });
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {

    return await execute(() async{
      final tokenFCM = LocalStorageHelper.getValue('fcm_token');
      RegisterRequest request = RegisterRequest(
          username: '$firstName $lastName', email: email, password: password, tokenFcm: tokenFCM);
      final BaseResponse<RegisterResponse> response = await apiServices.sendRegister(request);

      notifyListeners();
      if (response.code == 200 || response.code == 201) {
        showToastTop(
          message: response.message.toString(),
        );
        return true;
      } else {
        showToast(
          message: "${'auth.registration_failed'.tr()}: ${response.message}",
        );
        return false;
      }
    });

  }

  Future<bool> sendForgotPassword({required String email}) async {

    return await execute(() async{
      ForgotPasswordRequest request = ForgotPasswordRequest(
        email: email,
      );
      final BaseResponse<ForgotPasswordResponse> response =
          await apiServices.sendForgotPassword(request);

      notifyListeners();
      if (response.code == 200 || response.code == 201) {
        showToastTop(
          message: response.message.toString(),
        );
        return true;
      } else {
        showToast(
          message: "${'auth.forgot_password_failed'.tr()}: ${response.message}",
        );
        return false;
      }
    });

  }


  Future<bool> signInWithGoogle() async {

    return await execute(() async {

      try {
        // Bắt đầu quá trình đăng nhập Google
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return false;
        }

        // Lấy thông tin xác thực từ request
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Tạo credential cho Firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Đăng nhập vào Firebase với credential
        final UserCredential authResult = await _auth.signInWithCredential(credential);
        User? _user = authResult.user;


        // bool? isLoginSUCC = await checkLoginGoogle(_user!);

        notifyListeners();
        return true;
        // return isLoginSUCC ?? false;
      } catch (error) {
        print('LỖI ĐĂNG NHẬP GOOGLE: $error');
        showToast(message: "Đăng nhập thất bại: $error");
        return false;
      }
    });

  }


  Future<bool?> checkLoginGoogle(User user) async {
    bool isSend = await signIn(
        username: user.email!.trim(),
        password: user.uid.trim());

    if(isSend) return true;

    bool isSavaData = await signUp(
        firstName: user.displayName!.split(' ')[0],
        lastName: user.displayName!.split(' ')[1],
        email: user.email!.trim(),
        password: user.uid.trim());
    LocalStorageHelper.setValue("userName", "${user.displayName}");
    LocalStorageHelper.setValue("email", user.email);
    print("=====> ${authModel.email}");
    LocalStorageHelper.setValue("userId", 99);
    LocalStorageHelper.setValue("isAdmin", 0);
    return isSavaData ;
  }

  Future<void> signOut() async {
    return await execute(() async {;

      try {
        await _auth.signOut();
        await _googleSignIn.signOut();

        // Xóa thông tin đã lưu
        await LocalStorageHelper.deleteValue("googleUID");
        await LocalStorageHelper.deleteValue("googleEmail");
        await LocalStorageHelper.deleteValue("googleDisplayName");
        await LocalStorageHelper.deleteValue("googlePhotoURL");
        await LocalStorageHelper.deleteValue("googleToken");

        showToastTop(message: "Đã đăng xuất thành công");
        print('Đăng xuất thành công');
      } catch (error) {
        print('LỖI ĐĂNG XUẤT: $error');
        showToast(message: "Đăng xuất thất bại: $error");
      }
    });
  }

  void generateCaptcha() {
    const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz';
    const digits = '0123456789';

    Random random = Random();

    String captcha = '';
    captcha += uppercaseChars[random.nextInt(uppercaseChars.length)]; // Chữ hoa
    captcha += lowercaseChars[random.nextInt(lowercaseChars.length)]; // Chữ thường
    captcha += digits[random.nextInt(digits.length)]; // Số

    String allChars = uppercaseChars + lowercaseChars + digits;
    for (int i = captcha.length; i < 6; i++) {
      captcha += allChars[random.nextInt(allChars.length)];
    }

    captcha = _shuffleString(captcha);

    model.captchaText = captcha;
    notifyListeners();
  }

  String _shuffleString(String str) {
    List<String> chars = str.split('');
    chars.shuffle();
    return chars.join('');
  }



}
