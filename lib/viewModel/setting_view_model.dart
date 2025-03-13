import 'dart:convert';

import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/update_info_user_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/update_info_user_response.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';

import 'BaseViewModel.dart';

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
          error = 'Không tìm thấy ID người dùng';
          return false;
        }

        int userId;
        try {
          userId = userIdStr;
        } catch (e) {
          error = 'ID người dùng không hợp lệ $userIdStr';
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
          error = response.message ?? 'Có lỗi xảy ra khi cập nhật email';
          return false;
        }
      } catch (e) {
        error = 'Có lỗi xảy ra: $e';
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
          phoneNumber: newPhone,
        );

        final BaseResponse<UpdateInfoUserResponse> response =
            await apiServices.updateInfoUser(request);

        if (response.code == 200 || response.code == 201) {
          return true;
        } else {
          error =
              response.message ?? 'Có lỗi xảy ra khi cập nhật số điện thoại';
          return false;
        }
      } catch (e) {
        error = 'Có lỗi xảy ra: $e';
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
        error = 'Có lỗi xảy ra: $e';
        return false;
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  void updateInfoUser() async {
    UpdateInfoUserRequest request = UpdateInfoUserRequest(
        id: 7,
        email: "update3duser@example.com",
        phoneNumber: "0987654321",
        clickSendName: "Updated Name",
        clickSendKey: "UpdatedKey123");
    print('JSON request data: ${jsonEncode(request.toJson())}');

    final BaseResponse<UpdateInfoUserResponse> response =
        await apiServices.updateInfoUser(request);
    print('Code: ${response.code}');
    print('Status: ${response.status}');
    print('Message: ${response.message}');
    print('Error: ${response.error}');
    print('Data: ${response.data}');

    notifyListeners();
  }
}
