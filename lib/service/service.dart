import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:fire_guard/service/init.dart';

final getIt = GetIt.instance;

const String BASE_API_URL = StatusApi.BASE_API_URL; // Thay đổi base URL theo dự án của bạn
const int TIME_OUT = StatusApi.TIME_OUT; // Timeout cho các yêu cầu HTTP

// Hàm khởi tạo dịch vụ
Future<void> initServices(Interceptor Function() createInterceptor) async {
  getIt.registerSingleton<ApiServices>(
    ApiServices(
      _createDioWithInterceptor(createInterceptor),
      baseUrl: BASE_API_URL,
    ),
  );
}

// Hàm tạo Dio với Interceptor
Dio _createDioWithInterceptor(Interceptor Function() createInterceptor) {
  final dio = Dio(BaseOptions(
    baseUrl: BASE_API_URL,
    connectTimeout: const Duration(milliseconds: TIME_OUT),
  ));
  final interceptor = createInterceptor();
  if (interceptor != null) {
    dio.interceptors.add(interceptor);
  }
  return dio;
}

// Định nghĩa Interceptor mặc định
Interceptor get _defaultInterceptor {
  return InterceptorsWrapper(
    onRequest: (RequestOptions options, handler) async {
      print("Requesting: ${options.baseUrl}${options.path}");
      // Thêm header, xác thực hoặc thông tin khác vào request ở đây
      options.headers['content-type'] = 'application/json';
      final token = await _getAccessToken();
      if (token != null) {
        options.headers['Authorization'] = "Bearer $token";
      }
      return handler.next(options);
    },
    onResponse: (Response response, handler) {
      print("Response: [${response.statusCode}] ${response.data}");
      // Kiểm tra các mã phản hồi đặc biệt và xử lý
      if (response.data == "ERROR500") {
        _showErrorToast("Có lỗi hệ thống");
      }
      return handler.next(response);
    },
    onError: (DioError error, handler) async {
      print("Error: [${error.response?.statusCode}] ${error.response?.data}");
      if (error.response == null) {
        _showErrorToast("Không có kết nối mạng");
      } else if (error.response?.statusCode == 401) {
        _handleUnauthorized();
      } else if (error.response?.statusCode == 500) {
        _showErrorToast("Có lỗi hệ thống, vui lòng thử lại sau");
      }
      return handler.next(error);
    },
  );
}

// Hàm tạo Interceptor (được sử dụng trong initServices)
Interceptor createInterceptor() {
  return _defaultInterceptor;
}

// Hàm giả để lấy access token
Future<String?> _getAccessToken() async {
  // Thực hiện logic lấy token từ shared preferences hoặc nguồn khác
  return "your_access_token";
}

// Hàm xử lý khi không có quyền truy cập
void _handleUnauthorized() {
  // Ví dụ: Điều hướng đến màn hình đăng nhập
  print("Unauthorized access - Redirecting to login");
}

// Hàm hiển thị thông báo lỗi
void _showErrorToast(String message) {
  // Ví dụ: Sử dụng Toast để hiển thị thông báo lỗi
  print("Toast: $message");
}
