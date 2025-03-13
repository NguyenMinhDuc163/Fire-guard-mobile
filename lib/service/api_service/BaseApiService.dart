import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/base_connect.dart';
import 'package:fire_guard/service/service_config/network_service.dart';
import 'package:fire_guard/utils/core/common/dialog_alert.dart';
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
        DialogAlert.showTimeoutDialog('notification'.tr(), baseResponse.message.toString());
      }
      return baseResponse;
    } on DioException catch (e) {

      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        DialogAlert.showTimeoutDialog('error.connection_error'.tr(), 'error.connection_timeout'.tr());
      }else{
        DialogAlert.showTimeoutDialog('error.connection_error'.tr(), 'error.error_server'.tr());
      }

      if (e.response != null) {
        return BaseResponse.fromJson(
          e.response!.data,
              (json) => fromJson(json),
        );
      } else {
        DialogAlert.showTimeoutDialog('error.connection_error'.tr(), 'error.error_server'.tr());
        return BaseResponse<T>(error: 'DioError: ${e.message}');
      }
    } catch (e) {
      DialogAlert.showTimeoutDialog('error.connection_error'.tr(), 'error.error_server'.tr());
      return BaseResponse<T>(error: 'Unexpected Error: $e');
    }
  }


}
