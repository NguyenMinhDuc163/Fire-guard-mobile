import 'dart:convert';

import 'package:fire_guard/service/api_service/api_service.dart';
import 'package:fire_guard/service/api_service/request/user_location_request.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/api_service/response/save_location_response.dart';
import 'package:fire_guard/service/api_service/response/user_location_response.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/providers/BaseViewModel.dart';

class FireMapViewModel extends BaseViewModel{
  final ApiServices apiServices = ApiServices();


  Future<bool> saveLocation(
      {required String longitude, required String latitude, bool isFire = false}) async {
    return await execute(() async {
      UserLocationRequest request = UserLocationRequest(
          type: "save",
          longitude: longitude,
          latitude: latitude,
          userID: LocalStorageHelper.getValue('userId'),
          isFire: isFire);
      print('JSON request data: ${jsonEncode(request.toJson())}');

      final BaseResponse<SaveLocationResponse> response =
      await apiServices.saveLocationUser(request);
      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('Error: ${response.error}');
      print('Data: ${response.data}');
      notifyListeners();
      return response.code == 200 || response.code == 201;
    });
  }

  Future<BaseResponse<UserLocationResponse>> sendLocation() async {
    return await execute(() async {
      UserLocationRequest request = UserLocationRequest(
        type: "longitude",
      );

      print('JSON request data: ${jsonEncode(request.toJson())}');

      // Gọi API và nhận phản hồi
      final BaseResponse<UserLocationResponse> response =
      await apiServices.sendLocationUser(request);

      // Ghi log phản hồi
      print('Code: ${response.code}');
      print('Status: ${response.status}');
      print('Message: ${response.message}');
      print('Error: ${response.error}');
      print('Data: ${response.data}');

      // Gửi thông báo cập nhật
      notifyListeners();

      // Trả về phản hồi
      return response;
    });
  }

}