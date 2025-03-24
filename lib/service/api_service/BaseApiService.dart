import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/base_connect.dart';
import 'package:fire_guard/service/service_config/network_service.dart';
import 'package:fire_guard/utils/core/common/dialog_alert.dart';
import 'package:fire_guard/utils/core/common/toast.dart';
import 'package:fire_guard/utils/core/constants/constants.dart';
import 'package:fire_guard/utils/core/constants/dimension_constants.dart';
import 'package:flutter/material.dart';

abstract class BaseApiService {
  final Dio dio = NetworkService().dio;

  Future<BaseResponse<T>> sendRequest<T>(
      String url, {
        required T Function(Map<String, dynamic>) fromJson,
        String method = 'GET',
        dynamic data,
      }) async {
    try {
      Response response;

      // Chọn phương thức HTTP
      switch (method) {
        case 'POST':
          response = await dio.post(url, data: data);
          break;
        case 'PUT':
          response = await dio.put(url, data: data);
          break;
        case 'DELETE':
          response = await dio.delete(url, data: data);
          break;
        default:
          response = await dio.get(url, queryParameters: data);
      }
    final baseResponse = BaseResponse.fromJson(
      response.data,
          (json) => fromJson(json),
    );

      if(baseResponse.code != 200 && baseResponse.code != 201){
        print('Error: ${baseResponse.message}');
        DialogAlert.showTimeoutDialog(tile: 'home_screen.notification'.tr(), content: Constants.getErrorMessage(baseResponse.message.toString()) ?? "");
      }
      return baseResponse;

    } catch (e) {

      DialogAlert.showTimeoutDialog(tile:'error.connection_error'.tr(),content: 'error.error_server'.tr());

      return BaseResponse<T>(error: 'Unexpected Error: $e');
    }
  }


}
