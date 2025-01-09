import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/main.dart';
import 'package:fire_guard/models/auth_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/login_request.dart';
import 'package:fire_guard/service/api_service/request/register_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/login_response.dart';
import 'package:fire_guard/service/api_service/response/register_response.dart';
import 'package:fire_guard/service/service_config//notification_service.dart';
import 'package:fire_guard/utils/core/common/toast.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiServices apiServices = ApiServices();
  AuthModel authModel = AuthModel();
  AuthModel get model => authModel;

  Future<bool> signIn({required String username, required String password}) async {
    final tokenFCM = LocalStorageHelper.getValue('fcm_token');
    print('đã lấy được Token FCM: $tokenFCM');

    LoginRequest request = LoginRequest(
      email: username,
      password: password,
      // tokenFCM: tokenFCM,
    );
    final BaseResponse<LoginResponse> response = await apiServices.sendLogin(request);

    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');


    if (response.code != null) {
      for (var item in response.data!) {
        if (item.key == 'token'){
          LocalStorageHelper.setValue("authToken", item.value);
          print("da luu token: ${LocalStorageHelper.getValue('authToken')}");
        }

        if (item.key == 'user' && item.value is Map<String, dynamic>) {
          Map<String, dynamic> userMap = item.value as Map<String, dynamic>;
          String username = userMap['username'] ?? 'Nguyễn Minh Đức';
          String email = userMap['email'] ?? 'ngminhduc1603@gmail.com';
          int id = userMap['id'] ?? 1;
          LocalStorageHelper.setValue("userName", username);
          LocalStorageHelper.setValue("email", email);
          LocalStorageHelper.setValue("userId", id);

          print(
              '=>>>>>>Username: ${LocalStorageHelper.getValue('userName')} + Email: ${LocalStorageHelper.getValue('email')} + ID: ${LocalStorageHelper.getValue('userId')}');
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
  }

  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final tokenFCM = LocalStorageHelper.getValue('fcm_token');
    print('đã lấy được Token FCM: $tokenFCM');

    RegisterRequest request = RegisterRequest(
        username: '$firstName $lastName', email: email, password: password, tokenFcm: tokenFCM);
    final BaseResponse<RegisterResponse> response = await apiServices.sendRegister(request);
    // if (response.code != null) {
    //   showToast(
    //     message: 'registration_success'.tr(),
    //   );
    // } else {
    //   showToast(
    //     message: 'registration_failed'.tr(),
    //   );
    // }
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
  }
}
