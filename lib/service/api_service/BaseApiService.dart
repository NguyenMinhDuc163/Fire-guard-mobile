import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/network_service.dart';
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

      return BaseResponse.fromJson(
        response.data,
            (json) => fromJson(json),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        DialogAlert.showTimeoutDialog('connection_error'.tr(), 'connection_timeout'.tr());
      }
      if (e.response != null) {
        return BaseResponse.fromJson(
          e.response!.data,
              (json) => fromJson(json),
        );
      } else {
        return BaseResponse<T>(error: 'DioError: ${e.message}');
      }
    } catch (e) {
      return BaseResponse<T>(error: 'Unexpected Error: $e');
    }
  }


}
