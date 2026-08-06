# Kế hoạch triển khai AdMob cho Fire Guard Mobile

## 1. Mục tiêu

Tích hợp AdMob vào dự án Flutter:

`NguyenMinhDuc163/Fire-guard-mobile`

Mục tiêu kinh doanh là tạo nhiều lượt hiển thị quảng cáo trong những phiên sử dụng ngắn, nhưng không được chặn hoặc làm chậm các chức năng liên quan đến báo cháy và an toàn.

Chỉ triển khai các loại quảng cáo sau:

1. App Open Ad.
2. Banner Ad.
3. Interstitial Ad.
4. Native Ad trong danh sách Tin tức và Cẩm nang.

Không triển khai Rewarded Ad trong đợt này vì ứng dụng chưa có phần thưởng hoặc nội dung khóa phù hợp.

---

# 2. Nguyên tắc bắt buộc

## 2.1. Không làm lệch nghiệp vụ hiện tại

Không sửa nghiệp vụ của các màn hình:

* Đăng nhập.
* Đăng ký.
* Quên mật khẩu.
* Báo cháy.
* Gọi 114.
* Bản đồ báo cháy.
* Đăng ký tọa độ.
* Quản lý cảm biến.
* Lịch sử cảnh báo.
* Quản lý người thân.
* Cài đặt tài khoản.

Không thay đổi API, request model, response model, Provider hoặc ViewModel hiện có nếu không thực sự cần cho quảng cáo.

Không refactor các màn hình chỉ để làm code “đẹp hơn”.

Không đổi tên file, route hoặc class hiện có.

Không sửa giao diện ngoài phạm vi cần thiết để chèn quảng cáo.

## 2.2. Không over-engineering

Không tạo:

* Hệ thống feature flag phức tạp.
* Firebase Remote Config cho quảng cáo.
* Repository layer cho quảng cáo.
* Provider hoặc ChangeNotifier riêng cho từng loại quảng cáo.
* Dependency injection riêng cho quảng cáo.
* Event bus.
* Analytics abstraction.
* Nhiều interface hoặc abstract class không cần thiết.
* Hệ thống cấu hình theo từng màn hình.
* Nhiều biến môi trường quảng cáo.
* Cơ chế A/B testing.
* Mediation trong đợt này.

Chỉ dùng một service quản lý quảng cáo đơn giản và một số widget/helper nhỏ khi cần.

## 2.3. Chỉ cấu hình các key AdMob

Tất cả ID quảng cáo production phải được tập trung tại một file duy nhất.

Chỉ yêu cầu các giá trị sau:

```text
ANDROID_ADMOB_APP_ID
ANDROID_APP_OPEN_AD_UNIT_ID
ANDROID_BANNER_AD_UNIT_ID
ANDROID_INTERSTITIAL_AD_UNIT_ID
ANDROID_NATIVE_AD_UNIT_ID
```

Không yêu cầu thêm các tham số cấu hình từ người dùng.

Các thông số hành vi như số lần mở app, cooldown hoặc số nội dung đã đọc được đặt thành hằng số nội bộ trong service, không đưa vào `.env`, Remote Config hoặc file cấu hình bên ngoài.

Chỉ triển khai Android trong đợt này. Không thêm cấu hình iOS nếu chưa được yêu cầu.

---

# 3. Quy tắc về ID quảng cáo

Tạo một file đơn giản, ví dụ:

```text
lib/service/admob/admob_ids.dart
```

File này chịu trách nhiệm trả về ID quảng cáo.

Trong chế độ debug:

* Luôn sử dụng test Ad Unit ID chính thức của Google.
* Không sử dụng ID production khi `kDebugMode == true`.

Trong release:

* Sử dụng các placeholder production rõ ràng để chủ dự án thay thế.
* Không rải ID quảng cáo trực tiếp vào các màn hình.

Cấu trúc mong muốn:

```dart
class AdMobIds {
  static String get appOpenAdUnitId;
  static String get bannerAdUnitId;
  static String get interstitialAdUnitId;
  static String get nativeAdUnitId;
}
```

Không cần tạo model hoặc parser cho các ID này.

AdMob App ID của Android phải được khai báo đúng vị trí trong:

```text
android/app/src/main/AndroidManifest.xml
```

Không nhầm AdMob App ID với Ad Unit ID.

---

# 4. Dependency

Thêm dependency cần thiết vào `pubspec.yaml`:

```yaml
google_mobile_ads:
```

Sử dụng phiên bản tương thích với Flutter SDK hiện tại của dự án.

Không tự nâng cấp các dependency khác.

Không thay đổi các dependency override hiện tại.

Không chạy `flutter pub upgrade`.

---

# 5. Cấu trúc code tối thiểu

Chỉ nên tạo các file tương đương sau:

```text
lib/service/admob/admob_ids.dart
lib/service/admob/admob_service.dart
lib/service/admob/app_open_ad_manager.dart
lib/screens/widger/ad_banner_widget.dart
lib/screens/widger/native_ad_widget.dart
```

Có thể giảm số file nếu triển khai vẫn rõ ràng.

Không tạo thêm folder hoặc layer nếu không cần.

## 5.1. AdMobService

Dùng một singleton đơn giản:

```dart
AdMobService.instance
```

Service chịu trách nhiệm:

* Khởi tạo Mobile Ads.
* Preload Interstitial.
* Hiển thị Interstitial tại điểm phù hợp.
* Reload Interstitial sau khi đã đóng.
* Theo dõi cooldown đơn giản.
* Giải phóng quảng cáo khi cần.

Không để màn hình tự quản lý toàn bộ vòng đời của Interstitial.

Không dùng Provider cho service này.

## 5.2. AppOpenAdManager

Chỉ chịu trách nhiệm:

* Load App Open Ad.
* Hiển thị từ lần mở ứng dụng thứ hai.
* Không hiển thị hai lần liên tiếp.
* Không hiển thị khi đã có quảng cáo toàn màn hình khác đang mở.
* Không hiển thị khi người dùng vừa quay lại từ thao tác khẩn cấp.

Dùng `LocalStorageHelper` hiện có để lưu số lần mở ứng dụng.

Không tạo cơ chế lưu trữ mới.

Các hằng số có thể đặt trực tiếp trong manager:

```dart
static const int minimumLaunchCount = 2;
static const Duration minimumInterval = Duration(hours: 4);
```

Không đưa các giá trị này ra Remote Config.

---

# 6. Khởi tạo AdMob

Khởi tạo quảng cáo trong luồng startup hiện có.

Vị trí phù hợp là trong `main.dart`, sau khi Flutter binding đã được khởi tạo và trước hoặc ngay sau khi ứng dụng chạy.

Không được làm cho ứng dụng chờ quảng cáo mới hiển thị giao diện.

Không dùng `await` theo cách khiến Splash bị treo nếu SDK quảng cáo lỗi.

Luồng mong muốn:

```dart
await MobileAds.instance.initialize();
```

hoặc gọi khởi tạo không chặn startup nếu phù hợp với cấu trúc hiện tại.

Lỗi khởi tạo quảng cáo không được làm crash ứng dụng.

---

# 7. Vị trí hiển thị quảng cáo

## 7.1. Không đặt quảng cáo tại các màn hình sau

Tuyệt đối không đặt Banner, Native hoặc Interstitial tại:

* Splash lần đầu.
* Intro.
* Đăng nhập.
* Đăng ký.
* Quên mật khẩu.
* Trang chủ có nút Báo cháy.
* Màn hình gọi 114.
* Bản đồ báo cháy.
* Đăng ký tọa độ.
* Chi tiết thông báo cảnh báo.
* Popup cảnh báo an toàn.
* Popup xin quyền thông báo.
* Popup xin quyền vị trí.

Không được hiển thị Interstitial khi người dùng:

* Bấm Báo cháy.
* Bấm Gọi 114.
* Mở bản đồ.
* Mở Google Maps.
* Bật hoặc tắt cảm biến.
* Bật hoặc tắt còi.
* Thêm hoặc xóa người thân.
* Đổi mật khẩu, email hoặc số điện thoại.
* Xóa tài khoản.
* Đăng nhập hoặc đăng xuất.

## 7.2. Banner Ad

Tạo một widget tái sử dụng đơn giản:

```dart
AdBannerWidget()
```

Widget phải:

* Tự load Banner Ad.
* Chỉ render vùng quảng cáo khi đã load thành công.
* Dispose Banner Ad đúng cách.
* Không chiếm khoảng trắng lớn khi quảng cáo chưa tải.
* Không tự retry liên tục.
* Không làm ảnh hưởng nếu quảng cáo lỗi.

Dùng Anchored Adaptive Banner nếu triển khai không phức tạp. Nếu gây thay đổi lớn, dùng Banner tiêu chuẩn.

Đặt Banner tại:

### Tin tức

File dự kiến:

```text
lib/screens/fire_news_screen/views/fire_news_screen.dart
```

Đặt một Banner ở cuối màn hình hoặc phía trên BottomNavigationBar.

Không che danh sách.

### Cẩm nang

File dự kiến:

```text
lib/screens/fire_safety_skills_screen/views/fire_safety_skills_screen.dart
```

Đặt một Banner ở cuối màn hình.

### Hồ sơ cá nhân và IoT

File dự kiến:

```text
lib/screens/profile_screen/views/personal_profile_screen.dart
```

Đặt Banner:

* Sau phần thông tin thiết bị; hoặc
* Trước phần nút “Kiểm tra hệ thống” và “Báo cáo sự cố”.

Không đặt Banner sát các công tắc cảm biến.

### Lịch sử thông báo

File dự kiến:

```text
lib/screens/home_screen/views/notification_screen.dart
```

Đặt Banner sau khu vực lọc ngày và trước danh sách thông báo.

Không đặt trong popup chi tiết cảnh báo.

### Quản lý người thân

File dự kiến:

```text
lib/screens/family_manager_screen/views/family_management_screen.dart
```

Đặt Banner cuối danh sách hoặc phía dưới nội dung chính.

Không đặt gần nút thêm hoặc nút xóa thành viên.

### Cài đặt

File dự kiến:

```text
lib/screens/setting_screen/views/settings_screen.dart
```

Đặt Banner trong danh sách cài đặt, trước mục xóa tài khoản.

Phải có khoảng cách đủ lớn để tránh người dùng bấm nhầm vào “Xóa tài khoản”.

---

# 8. Native Ad

Chỉ triển khai Native Ad trong hai danh sách:

* Tin tức.
* Cẩm nang PCCC.

Không dùng Native Ad ở các màn hình khác.

## 8.1. Danh sách Tin tức

Với danh sách nội dung thực tế:

* Chèn Native Ad đầu tiên sau 2 bài viết.
* Sau đó chèn thêm sau mỗi 5 bài viết.
* Tối đa 2 Native Ad trong một danh sách.

Ví dụ:

```text
Bài 1
Bài 2
Native Ad
Bài 3
Bài 4
Bài 5
Bài 6
Bài 7
Native Ad
```

Không chỉnh sửa model API để chèn object quảng cáo vào danh sách.

Có thể xử lý index hiển thị tại UI hoặc tạo một danh sách item hiển thị cục bộ trong màn hình.

Không thay đổi dữ liệu gốc trong ViewModel.

Native Ad phải có nhãn rõ:

```text
Quảng cáo
```

Không làm Native Ad giống hoàn toàn một bài viết thật đến mức gây nhầm lẫn.

## 8.2. Danh sách Cẩm nang

Áp dụng cùng quy tắc:

* Native đầu tiên sau 2 nội dung.
* Sau đó mỗi 5 nội dung.
* Tối đa 2 quảng cáo.

Không thay đổi API hoặc model cẩm nang.

## 8.3. Native platform factory

Nếu `google_mobile_ads` bắt buộc phải đăng ký NativeAdFactory trên Android:

* Tạo đúng một factory đơn giản.
* Dùng layout tối giản.
* Không tạo nhiều template.
* Không triển khai factory riêng cho Tin tức và Cẩm nang.
* Cả hai vị trí dùng chung một native layout.

Nếu việc tạo Native Ad làm phát sinh thay đổi Android quá lớn hoặc không thể xác minh tĩnh đáng tin cậy, ưu tiên hoàn thành App Open, Banner và Interstitial trước; ghi rõ phần Native chưa hoàn thành thay vì viết code không chắc chắn.

---

# 9. Interstitial Ad

Interstitial chỉ được sử dụng khi người dùng hoàn thành việc xem nội dung.

Các điểm hợp lệ:

* Người dùng đọc xong một bài Tin tức và quay lại danh sách.
* Người dùng đọc xong một nội dung Cẩm nang và quay lại danh sách.

Không hiển thị trước khi mở bài viết.

Không hiển thị ngay khi người dùng bấm một tab.

Không hiển thị khi người dùng chỉ bấm nút quay lại trong các màn hình chức năng khác.

## 9.1. Quy tắc hiển thị

Dùng các hằng số nội bộ:

```dart
static const int contentThreshold = 2;
static const Duration minimumInterval = Duration(seconds: 90);
static const int maximumPerSession = 3;
```

Luồng:

1. Mỗi lần người dùng hoàn thành một nội dung, tăng bộ đếm.
2. Khi đạt 2 nội dung, thử hiển thị Interstitial.
3. Chỉ hiển thị nếu:

   * Quảng cáo đã load.
   * Đã qua ít nhất 90 giây từ quảng cáo toàn màn hình gần nhất.
   * Phiên hiện tại chưa hiển thị quá 3 Interstitial.
   * Không có App Open Ad hoặc Interstitial khác đang hiển thị.
4. Sau khi hiển thị, reset bộ đếm nội dung.
5. Sau khi quảng cáo đóng hoặc lỗi, preload quảng cáo tiếp theo.

Nếu quảng cáo chưa load:

* Cho người dùng tiếp tục bình thường.
* Không chờ quảng cáo.
* Không hiện quảng cáo muộn ở màn hình kế tiếp.

## 9.2. Cách xác định “đọc xong”

Không cần xây tracking thời gian đọc phức tạp.

Chỉ cần đánh dấu khi:

* Người dùng đã mở màn hình chi tiết.
* Sau đó quay lại danh sách bằng back navigation.

Không cần đo scroll depth.

Không cần đo thời gian đọc.

Không cần gửi analytics event.

---

# 10. App Open Ad

App Open Ad chỉ được hiển thị:

* Từ lần mở ứng dụng thứ hai.
* Khi ứng dụng khởi động hoặc quay lại foreground.
* Khi đã qua ít nhất 4 giờ từ lần hiển thị App Open gần nhất.

Không hiển thị App Open khi:

* Người dùng quay lại từ ứng dụng gọi điện.
* Người dùng quay lại từ Google Maps.
* Người dùng quay lại từ màn hình cài đặt quyền.
* Người dùng quay lại từ ứng dụng email.
* Interstitial vừa được hiển thị.
* Một quảng cáo toàn màn hình khác đang mở.

Dùng một cờ đơn giản trong bộ nhớ như:

```dart
bool suppressNextAppOpenAd
```

Trước khi mở các ứng dụng ngoài từ các luồng khẩn cấp, đặt cờ này thành `true`.

Khi ứng dụng quay lại foreground:

* Nếu cờ là `true`, bỏ qua một lần App Open và reset cờ.
* Không tạo hệ thống navigation observer phức tạp nếu không cần.

Không hiển thị App Open trong lần người dùng xem Intro đầu tiên.

---

# 11. Consent quảng cáo

Tích hợp consent theo cách tối thiểu mà SDK hỗ trợ.

Yêu cầu:

* Cập nhật consent information khi app khởi động.
* Hiển thị consent form nếu SDK yêu cầu.
* Chỉ request quảng cáo khi được phép request ads.
* Nếu consent flow lỗi, ứng dụng vẫn phải mở bình thường.

Không xây màn hình consent riêng.

Không lưu consent bằng Hive thủ công nếu SDK đã quản lý.

Không thêm nhiều option hoặc cấu hình privacy ngoài những gì SDK yêu cầu.

Nếu phần consent không thể xác minh tĩnh do API của phiên bản package khác với dự kiến, kiểm tra đúng API trong package đang dùng và triển khai theo API thực tế. Không viết code dựa trên phỏng đoán.

---

# 12. Trạng thái và xử lý lỗi

Mọi lỗi quảng cáo phải được xử lý im lặng.

Được phép:

```dart
debugPrint(...)
```

Không hiển thị Toast, SnackBar hoặc Dialog khi quảng cáo load lỗi.

Quảng cáo lỗi không được:

* Chặn màn hình.
* Chặn navigation.
* Chặn thao tác người dùng.
* Làm loading vô hạn.
* Làm crash app.

Tất cả Ad object phải được dispose đúng vòng đời.

Không preload nhiều instance cùng loại cùng lúc.

---

# 13. Những file được phép sửa

Dự kiến chỉ sửa các file sau và các file Android bắt buộc:

```text
pubspec.yaml
lib/main.dart
android/app/src/main/AndroidManifest.xml

lib/service/admob/admob_ids.dart
lib/service/admob/admob_service.dart
lib/service/admob/app_open_ad_manager.dart

lib/screens/widger/ad_banner_widget.dart
lib/screens/widger/native_ad_widget.dart

lib/screens/main_app.dart
lib/screens/fire_news_screen/views/fire_news_screen.dart
lib/screens/fire_news_screen/views/news_detail_screen.dart
lib/screens/fire_safety_skills_screen/views/fire_safety_skills_screen.dart
lib/screens/profile_screen/views/personal_profile_screen.dart
lib/screens/home_screen/views/notification_screen.dart
lib/screens/family_manager_screen/views/family_management_screen.dart
lib/screens/setting_screen/views/settings_screen.dart
```

Nếu Native Ad yêu cầu Android factory, được phép sửa hoặc tạo thêm file dưới:

```text
android/app/src/main/kotlin/
android/app/src/main/res/layout/
```

Không sửa các file API, request, response hoặc backend service.

Nếu cần sửa file ngoài danh sách này, phải có lý do trực tiếp liên quan đến AdMob.

---

# 14. Thứ tự triển khai

Thực hiện đúng thứ tự sau:

## Bước 1: Kiểm tra cấu trúc hiện tại

Đọc:

* `pubspec.yaml`
* `lib/main.dart`
* `lib/screens/main_app.dart`
* Các màn hình sẽ đặt quảng cáo.
* Android package name và `MainActivity`.
* Cách dự án dùng `LocalStorageHelper`.

Không sửa code trước khi xác định đúng vị trí.

## Bước 2: Thêm dependency và App ID

* Thêm `google_mobile_ads`.
* Thêm AdMob App ID vào AndroidManifest.
* Không sửa cấu hình Android khác nếu không cần.

## Bước 3: Tạo `AdMobIds`

* Debug dùng test ID.
* Release dùng placeholder production.
* Chỉ một file chứa ID.

## Bước 4: Tạo service quảng cáo

* Khởi tạo SDK.
* Interstitial load/show/reload.
* Trạng thái full-screen ad.
* Counter và cooldown đơn giản.

## Bước 5: Tạo Banner widget

* Dùng lại trên các màn hình.
* Dispose đúng.
* Không để khoảng trắng khi chưa load.

## Bước 6: Tích hợp App Open

* Từ lần mở thứ hai.
* Cooldown 4 giờ.
* Bỏ qua khi quay lại từ thao tác khẩn cấp.

## Bước 7: Tích hợp Interstitial

* Chỉ sau khi đóng chi tiết Tin tức hoặc Cẩm nang.
* Sau mỗi 2 nội dung.
* Cooldown 90 giây.
* Tối đa 3 lần mỗi phiên.

## Bước 8: Tích hợp Banner

Thêm vào:

* Tin tức.
* Cẩm nang.
* Hồ sơ.
* Thông báo.
* Người thân.
* Cài đặt.

## Bước 9: Tích hợp Native

* Chỉ Tin tức và Cẩm nang.
* Sau item thứ 2.
* Sau đó mỗi 5 item.
* Tối đa 2 item quảng cáo.

## Bước 10: Format và kiểm tra tĩnh

Không build.

---

# 15. Quy định kiểm tra

Dự án sử dụng FVM.

Chỉ chạy các lệnh sau:

```bash
fvm flutter pub get
fvm dart format lib
fvm flutter analyze
```

Nếu có thay đổi code Android/Kotlin, vẫn chỉ kiểm tra bằng phân tích tĩnh và đọc lại code.

Không chạy:

```bash
flutter run
flutter build apk
flutter build appbundle
flutter build ios
fvm flutter run
fvm flutter build apk
fvm flutter build appbundle
gradlew
./gradlew
pod install
pod update
```

Không chạy emulator.

Không khởi động thiết bị.

Không build debug hoặc release.

Không chạy các tác vụ Gradle vì tốn tài nguyên.

Nếu `fvm flutter analyze` báo lỗi đã tồn tại từ trước:

* Xác định lỗi có liên quan đến thay đổi AdMob hay không.
* Chỉ sửa lỗi do phần triển khai mới gây ra.
* Không mở rộng phạm vi để sửa toàn bộ warning cũ của dự án.

Không dùng `flutter` trực tiếp. Luôn dùng `fvm flutter`.

---

# 16. Tiêu chí hoàn thành

Công việc được xem là hoàn thành khi:

1. `google_mobile_ads` được thêm đúng cách.
2. AndroidManifest có placeholder AdMob App ID rõ ràng.
3. Debug sử dụng test ID của Google.
4. Production ID chỉ nằm trong một file.
5. App Open không chạy trong lần mở đầu tiên.
6. Banner được đặt đúng các màn hình phụ.
7. Native chỉ xuất hiện trong Tin tức và Cẩm nang.
8. Interstitial chỉ xuất hiện sau khi hoàn thành nội dung.
9. Không có quảng cáo trên Trang chủ khẩn cấp, bản đồ hoặc luồng tài khoản.
10. Không có thao tác khẩn cấp nào bị chặn bởi quảng cáo.
11. Quảng cáo lỗi không làm ảnh hưởng ứng dụng.
12. Tất cả Ad object được dispose hợp lý.
13. Code được format.
14. Không có lỗi phân tích tĩnh mới do AdMob.
15. Không có lệnh build nào được chạy.

---

# 17. Báo cáo cuối cùng của Codex

Sau khi hoàn thành, báo cáo ngắn gọn theo mẫu:

```text
Đã triển khai:
- App Open Ad
- Banner Ad
- Interstitial Ad
- Native Ad
- Consent flow

Các màn hình có quảng cáo:
- ...
- ...

Các màn hình cố ý không có quảng cáo:
- ...
- ...

File chứa AdMob ID:
- ...

Các placeholder cần chủ dự án thay:
- ANDROID_ADMOB_APP_ID
- ANDROID_APP_OPEN_AD_UNIT_ID
- ANDROID_BANNER_AD_UNIT_ID
- ANDROID_INTERSTITIAL_AD_UNIT_ID
- ANDROID_NATIVE_AD_UNIT_ID

Đã kiểm tra:
- fvm flutter pub get
- fvm dart format lib
- fvm flutter analyze

Không thực hiện:
- Không chạy app
- Không chạy emulator
- Không build APK/AAB
- Không chạy Gradle
```

Nếu một phần chưa thể triển khai chắc chắn, đặc biệt là Native Ad Factory, phải ghi rõ phần chưa hoàn thành. Không được tuyên bố đã hoàn thành nếu chỉ thêm code placeholder hoặc code chưa thể phân tích tĩnh.
