import 'package:dio/dio.dart';
import 'package:fire_guard/service/network_service.dart';
import 'response/api_response.dart';

abstract class BaseApiService {
  final Dio dio = NetworkService().dio;

  // Hàm dùng chung cho các request HTTP
  Future<ApiResponse<T>> sendRequest<T>(
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

      // Xử lý nếu status code là 200
      if (response.statusCode == 200) {
        return ApiResponse(data: fromJson(response.data));
      } else {
        return ApiResponse(
            error: 'Server error: ${response.statusCode} - ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse(
            error:
            'DioError: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        return ApiResponse(error: 'DioError: ${e.message}');
      }
    } catch (e) {
      return ApiResponse(error: 'Unexpected Error: $e');
    }
  }
}
