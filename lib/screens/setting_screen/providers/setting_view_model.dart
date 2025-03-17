import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/init.dart';
import 'package:fire_guard/screens/setting_screen/models/personal_profile_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/change_password_request.dart';
import 'package:fire_guard/service/api_service/request/update_info_user_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/change_password_response.dart';
import 'package:fire_guard/service/api_service/response/update_info_user_response.dart';
import 'package:fire_guard/providers/BaseViewModel.dart';

class SettingViewModel extends BaseViewModel {
  final ApiServices apiServices = ApiServices();
  bool isLoading = false;
  String? error;

  Future<bool> updateEmail(String newEmail) async {
    return await execute(() async {
      try {
        isLoading = true;
        error = null;
        notifyListeners();

        final userIdStr = LocalStorageHelper.getValue('userId');
        print('userIdStr: $userIdStr');
        if (userIdStr == null) {
          error = 'settings.user_id_not_found'.tr();
          return false;
        }

        int userId;
        try {
          userId = userIdStr;
        } catch (e) {
          error = 'settings.invalid_user_id'.tr() +  userIdStr;
          return false;
        }

        UpdateInfoUserRequest request = UpdateInfoUserRequest(
          id: userId,
          email: newEmail,
        );

        final BaseResponse<UpdateInfoUserResponse> response =
        await apiServices.updateInfoUser(request);

        if (response.code == 200 || response.code == 201) {
          return true;
        } else {
          error = response.message ?? 'settings.error_updating_email'.tr();
          return false;
        }
      } catch (e) {
        error = 'settings.error_occurred'.tr() +  e.toString();
        return false;
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<bool> updatePhone(String newPhone) async {
    return await execute(() async {
      try {
        isLoading = true;
        error = null;
        notifyListeners();

        final userIdStr = LocalStorageHelper.getValue('userId');

        if (userIdStr == null) {
          error = 'settings.user_id_not_found'.tr();
          return false;
        }

        int userId;
        try {
          userId = userIdStr;
        } catch (e) {
          error = 'settings.invalid_user_id'.tr();
          return false;
        }

        UpdateInfoUserRequest request = UpdateInfoUserRequest(
          id: userId,
          phoneNumber: newPhone,
        );

        final BaseResponse<UpdateInfoUserResponse> response =
        await apiServices.updateInfoUser(request);

        if (response.code == 200 || response.code == 201) {
          return true;
        } else {
          error =
              response.message ?? 'settings.error_updating_phone'.tr();
          return false;
        }
      } catch (e) {
         error = 'settings.error_occurred'.tr() +  e.toString();
        return false;
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<bool> updateClickSendInfo({
    required String name,
    required String key,
  }) async {
    return await execute(() async {
      try {
        isLoading = true;
        error = null;
        notifyListeners();

        final userIdStr = LocalStorageHelper.getValue('userId');
        if (userIdStr == null) {
          error = 'Không tìm thấy ID người dùng';
          return false;
        }

        int userId;
        try {
          userId = userIdStr;
        } catch (e) {
          error = 'ID người dùng không hợp lệ';
          return false;
        }

        UpdateInfoUserRequest request = UpdateInfoUserRequest(
          id: userId,
          clickSendName: name,
          clickSendKey: key,
        );

        final BaseResponse<UpdateInfoUserResponse> response =
        await apiServices.updateInfoUser(request);

        if (response.code == 200 || response.code == 201) {
          // Lưu thông tin mới vào LocalStorage
          LocalStorageHelper.setValue('clickSendName', name);
          LocalStorageHelper.setValue('clickSendKey', key);
          return true;
        } else {
          error = response.message ??
              'Có lỗi xảy ra khi cập nhật thông tin ClickSend';
          return false;
        }
      } catch (e) {
         error = 'settings.error_occurred'.tr() +  e.toString();
        return false;
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  // void updateInfoUser() async {
  //   UpdateInfoUserRequest request = UpdateInfoUserRequest(
  //       id: 7,
  //       email: "update3duser@example.com",
  //       phoneNumber: "0987654321",
  //       clickSendName: "Updated Name",
  //       clickSendKey: "UpdatedKey123");
  //   print('JSON request data: ${jsonEncode(request.toJson())}');
  //
  //   final BaseResponse<UpdateInfoUserResponse> response =
  //   await apiServices.updateInfoUser(request);
  //   print('Code: ${response.code}');
  //   print('Status: ${response.status}');
  //   print('Message: ${response.message}');
  //   print('Error: ${response.error}');
  //   print('Data: ${response.data}');
  //
  //   notifyListeners();
  // }

  Future<bool> changePassword({required String oldPassword, required String newPassword}) async {
    return await execute(() async {
      ChangePasswordRequest request = ChangePasswordRequest(
        userID: LocalStorageHelper.getValue('userID') ?? 7,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      try {
        print('JSON request data: ${jsonEncode(request.toJson())}');

        final BaseResponse<ChangePasswordResponse> response =
        await apiServices.changePassword(request);

        print('Code: ${response.code}');
        print('Status: ${response.status}');
        print('Message: ${response.message}');
        print('Error: ${response.error}');
        print('Data: ${response.data}');

        showToastTop(message: response.message ?? 'settings.change_password_success'.tr());
        return response.code == 200 || response.code == 201;
      } catch (e) {
        print('Error: $e');
        return false;
      } finally {}
    });
  }
}
