import 'package:dio/dio.dart';
import 'package:fire_guard/service/api_service/response/base_response.dart';
import 'package:fire_guard/service/network_service.dart';

abstract class BaseApiService {
  final Dio dio = NetworkService().dio;

  // Hàm dùng chung cho các request HTTP
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

      // Map dữ liệu khi thành công
      return BaseResponse.fromJson(
        response.data,
            (json) => fromJson(json),
      );
    } on DioException catch (e) {
      // Trường hợp lỗi với phản hồi từ server
      if (e.response != null) {
        return BaseResponse.fromJson(
          e.response!.data,
              (json) => fromJson(json),
        );
      } else {
        // Trường hợp lỗi không có phản hồi từ server
        return BaseResponse<T>(error: 'DioError: ${e.message}');
      }
    } catch (e) {
      // Trường hợp lỗi không mong muốn
      return BaseResponse<T>(error: 'Unexpected Error: $e');
    }
  }

}
