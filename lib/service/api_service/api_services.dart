import 'package:fire_guard/service/init.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';


part 'api_services.g.dart'; // Đảm bảo tên file khớp với tên file gốc


// flutter pub run build_runner build --delete-conflicting-outputs
@RestApi()
abstract class ApiServices {
  // Factory constructor để tạo instance của ApiServices
  factory ApiServices(Dio dio, {String? baseUrl, ParseErrorLogger errorLogger}) = _ApiServices;

  // Định nghĩa các phương thức API
  @POST("api/authentication")
  Future<UserResponse> authentication({
    @Body() required AuthenticationRequest request,
  });
}
