import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/models/auth_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/forgot_password_request.dart';
import 'package:fire_guard/service/api_service/request/login_request.dart';
import 'package:fire_guard/service/api_service/request/register_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/forgot_password_response.dart';
import 'package:fire_guard/service/api_service/response/login_response.dart';
import 'package:fire_guard/service/api_service/response/register_response.dart';
import 'package:fire_guard/utils/core/common/toast.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';

import 'BaseViewModel.dart';

class AuthViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  AuthModel authModel = AuthModel();
  AuthModel get model => authModel;

  Future<bool> signIn({required String username, required String password}) async {
    return await execute(() async{

      LoginRequest request = LoginRequest(
        email: username,
        password: password,
      );
      final BaseResponse<LoginResponse> response = await apiServices.sendLogin(request);

      if (response.code != null) {
        for (var item in response.data!) {
          if (item.key == 'token'){
            LocalStorageHelper.setValue("authToken", item.value);
          }

          if (item.key == 'user' && item.value is Map<String, dynamic>) {
            Map<String, dynamic> userMap = item.value as Map<String, dynamic>;
            LocalStorageHelper.setValue("userName", userMap['username']);
            LocalStorageHelper.setValue("email", userMap['email']);
            LocalStorageHelper.setValue("userId", userMap['id']);
            LocalStorageHelper.setValue("isAdmin", userMap["is_admin"]);

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
          message: "login_failed".tr(),
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
      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('Error: ${response.error}');
      print('Data: ${response.data}');

      notifyListeners();
      if (response.code == 200 || response.code == 201) {
        showToastTop(
          message: response.message.toString(),
        );
        return true;
      } else {
        showToast(
          message: "${'registration_failed'.tr()}: ${response.message}",
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
      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('Error: ${response.error}');
      print('Data: ${response.data}');

      notifyListeners();
      if (response.code == 200 || response.code == 201) {
        showToastTop(
          message: response.message.toString(),
        );
        return true;
      } else {
        showToast(
          message: "${'forgot_password_failed'.tr()}: ${response.message}",
        );
        return false;
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
