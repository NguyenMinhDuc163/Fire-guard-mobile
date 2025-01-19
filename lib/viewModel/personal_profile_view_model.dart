import 'dart:convert';

import 'package:fire_guard/init.dart';
import 'package:fire_guard/models/personal_profile_model.dart';
import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/change_password_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/change_password_response.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/cupertino.dart';

class PersonalProfileViewModel extends ChangeNotifier {
  final ApiServices apiServices = ApiServices();
  PersonalProfileModel personalProfileModel = PersonalProfileModel();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  PersonalProfileModel get model => personalProfileModel;

  void setPersonalProfile({required String name, required String email}) {
    model.name = name;
    model.email = email;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> changePassword({required String oldPassword, required String newPassword}) async {
    _setLoading(true); // Bắt đầu hiển thị loading
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

      showToastTop(message: response.message ?? 'Change password successfully');
      return response.code == 200 || response.code == 201;
    } catch (e) {
      print('Error: $e');
      return false;
    } finally {
      _setLoading(false); // Tắt loading bất kể request thành công hay thất bại
    }
  }
}
