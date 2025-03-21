// import 'package:fire_guard/providers/BaseViewModel.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:fire_guard/utils/core/common/toast.dart';
// import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
//
// class AuthProvider extends BaseViewModel {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//
//   User? _user;
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   // Getters
//   User? get user => _user;
//   bool get isLoading => _isLoading;
//   bool get isLoggedIn => _user != null;
//   String? get errorMessage => _errorMessage;
//
//   AuthProvider() {
//     // Theo dõi thay đổi trạng thái đăng nhập
//     _auth.authStateChanges().listen((User? user) {
//       _user = user;
//       notifyListeners();
//     });
//   }
//
//   // Đăng nhập với Google
//   Future<User?> signInWithGoogle() async {
//     return await execute(() async {
//       _setLoading(true);
//       _clearError();
//
//       try {
//         // Bắt đầu quá trình đăng nhập Google
//         final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//
//         if (googleUser == null) {
//           // Người dùng hủy đăng nhập
//           _setLoading(false);
//           return null;
//         }
//
//         // Lấy thông tin xác thực từ request
//         final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//         // Tạo credential cho Firebase
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//
//         // Đăng nhập vào Firebase với credential
//         final UserCredential authResult = await _auth.signInWithCredential(credential);
//         _user = authResult.user;
//
//         // In ra thông tin người dùng
//         print('---------- THÔNG TIN NGƯỜI DÙNG GOOGLE ----------');
//         print('UID: ${_user?.uid}');
//         print('Email: ${_user?.email}');
//         print('Display Name: ${_user?.displayName}');
//         print('Photo URL: ${_user?.photoURL}');
//         print('Email Verified: ${_user?.emailVerified}');
//         print('Phone Number: ${_user?.phoneNumber}');
//         print('Provider ID: ${_user!.providerData.isNotEmpty ? _user?.providerData[0].providerId : "null"}');
//
//         // Lấy token từ Firebase
//         String? token = await _user?.getIdToken();
//         print('Token: ${token?.substring(0, 50)}... (đã cắt bớt)');
//
//         // Lưu thông tin vào LocalStorage
//         if (_user != null) {
//           await LocalStorageHelper.setValue("googleUID", _user!.uid);
//           await LocalStorageHelper.setValue("googleEmail", _user!.email ?? "");
//           await LocalStorageHelper.setValue("googleDisplayName", _user!.displayName ?? "");
//           await LocalStorageHelper.setValue("googlePhotoURL", _user!.photoURL ?? "");
//
//           // Lưu token nếu cần sử dụng sau này
//           if (token != null) {
//             await LocalStorageHelper.setValue("googleToken", token);
//           }
//
//           // Hiển thị thông báo thành công
//           showToastTop(message: "Đăng nhập Google thành công: ${_user!.displayName}");
//         }
//
//         print('---------- KẾT THÚC THÔNG TIN ----------');
//
//         _setLoading(false);
//         notifyListeners();
//
//         return _user;
//       } catch (error) {
//         print('LỖI ĐĂNG NHẬP GOOGLE: $error');
//         _setError(error.toString());
//         showToast(message: "Đăng nhập thất bại: $error");
//         _setLoading(false);
//         return null;
//       }
//     });
//   }
//
//   // Đăng xuất
//   Future<void> signOut() async {
//     return await execute(() async {
//       _setLoading(true);
//
//       try {
//         print('Đang đăng xuất...');
//         await _auth.signOut();
//         await _googleSignIn.signOut();
//         _user = null;
//
//         // Xóa thông tin đã lưu
//         await LocalStorageHelper.deleteValue("googleUID");
//         await LocalStorageHelper.deleteValue("googleEmail");
//         await LocalStorageHelper.deleteValue("googleDisplayName");
//         await LocalStorageHelper.deleteValue("googlePhotoURL");
//         await LocalStorageHelper.deleteValue("googleToken");
//
//         showToastTop(message: "Đã đăng xuất thành công");
//         print('Đăng xuất thành công');
//       } catch (error) {
//         print('LỖI ĐĂNG XUẤT: $error');
//         _setError(error.toString());
//         showToast(message: "Đăng xuất thất bại: $error");
//       } finally {
//         _setLoading(false);
//       }
//     });
//   }
//
//   // Kiểm tra đăng nhập hiện tại
//   Future<User?> getCurrentUser() async {
//     _user = _auth.currentUser;
//
//     if (_user != null) {
//       print('---------- THÔNG TIN NGƯỜI DÙNG HIỆN TẠI ----------');
//       print('UID: ${_user?.uid}');
//       print('Email: ${_user?.email}');
//       print('Display Name: ${_user?.displayName}');
//       print('---------- KẾT THÚC THÔNG TIN ----------');
//     } else {
//       print('Không có người dùng đăng nhập');
//     }
//
//     return _user;
//   }
//
//   // Lấy thông tin người dùng dưới dạng Map
//   Map<String, dynamic> getUserInfo() {
//     if (_user == null) {
//       return {};
//     }
//
//     return {
//       'uid': _user!.uid,
//       'email': _user!.email,
//       'displayName': _user!.displayName,
//       'photoURL': _user!.photoURL,
//       'emailVerified': _user!.emailVerified,
//       'phoneNumber': _user!.phoneNumber,
//       'providerId': _user!.providerData.isNotEmpty ? _user!.providerData[0].providerId : null,
//     };
//   }
//
//   // Helpers
//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }
//
//   void _setError(String error) {
//     _errorMessage = error;
//     notifyListeners();
//   }
//
//   void _clearError() {
//     _errorMessage = null;
//     notifyListeners();
//   }
// }