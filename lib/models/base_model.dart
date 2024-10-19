import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  final ValueNotifier<bool> loading = ValueNotifier<bool>(false);
  final ValueNotifier<String> error = ValueNotifier<String>('');
  final ValueNotifier<String> success = ValueNotifier<String>('');



  void setLoading({required bool loading, required String source}) {
    print("setLoading: $source >> $loading");
    this.loading.value = loading;
  }

  void setError({required String error, required String source}) {
    //thêm responseCode ở đây để check các trường hợp khác thành công.
    // SharePreferUtils.logOutApp();
    // đồng ý thoát app xóa các trang cũ đi
    // Phoenix.rebirth(context);

    if (error?.isNotEmpty == true)
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ERROR>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    print("setError: $source >> $error");
    if (error?.isNotEmpty == true)
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>ERROR>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    this.error.value = error;
    this.loading.value = false;
  }

  void setSuccess({required String message, required String source}) {
    print("setSuccess: $source >> $message");
    this.success.value = message;
    this.loading.value = false;
  }

  void clearError({required String source}) {
    setError(error: '', source: source);
  }

}
