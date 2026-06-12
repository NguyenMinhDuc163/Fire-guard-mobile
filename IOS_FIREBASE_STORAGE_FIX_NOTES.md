# Ghi chú sửa lỗi iOS Firebase Storage

Ngày ghi chú: 2026-06-13

## Lỗi gặp phải

Khi build Flutter iOS, Xcode báo:

```text
/Users/seatech/.pub-cache/hosted/pub.dev/firebase_storage-11.7.7/ios/Classes/FLTTaskStateChannelStreamHandler.h:14:9
'FirebaseStorage/FirebaseStorage.h' file not found
```

Sau khi đổi về `Firebase/Firebase.h`, Xcode báo tiếp:

```text
Include of non-modular header inside framework module 'firebase_storage.FLTTaskStateChannelStreamHandler':
'/Users/seatech/Desktop/project/workspace/GenZ-Money-Mate/ios/Pods/Headers/Public/Firebase/Firebase.h'
```

## Nguyên nhân

Không phải do thiếu package Dart `firebase_storage`.

`pubspec.lock` và `ios/Podfile.lock` đều đã có:

- `firebase_storage 11.7.7`
- `firebase_core 2.32.0`
- Firebase iOS SDK `10.25.0`
- Pod `Firebase/Storage`
- Pod `FirebaseStorage`

Nguyên nhân chính là cách import header iOS không phù hợp khi project đang dùng:

```ruby
use_frameworks! :linkage => :static
```

Trong setup này, `firebase_storage` được build như framework module. Vì vậy public header của plugin không nên include umbrella header:

```objc
#import <Firebase/Firebase.h>
```

và cũng không nên dùng:

```objc
#import <FirebaseStorage/FirebaseStorage.h>
```

vì pod Firebase Storage hiện tại không expose file public header tên `FirebaseStorage.h`.

Cách phù hợp là dùng module import:

```objc
@import FirebaseCore;
@import FirebaseStorage;
```

## Những gì đã sửa

### 1. `ios/Podfile`

Trong `post_install`, giữ cơ chế patch import cho Firebase plugin, nhưng cấu hình riêng cho `firebase_storage` dùng module import:

```ruby
firebase_import_patches = {
  '.symlinks/plugins/firebase_auth/ios/Classes' => [
    '#import <FirebaseCore/FirebaseCore.h>',
    '#import <FirebaseAuth/FirebaseAuth.h>',
  ],
  '.symlinks/plugins/firebase_storage/ios/Classes' => [
    '@import FirebaseCore;',
    '@import FirebaseStorage;',
  ],
}
```

Ý nghĩa: sau này mỗi lần chạy `pod install`, nếu plugin trong `.pub-cache` bị quay về import cũ:

```objc
#import <Firebase/Firebase.h>
```

thì Podfile sẽ tự thay bằng module import phù hợp.

### 2. Các file trong `firebase_storage-11.7.7`

Các file sau đã được đổi import:

```text
/Users/seatech/.pub-cache/hosted/pub.dev/firebase_storage-11.7.7/ios/Classes/FLTTaskStateChannelStreamHandler.h
/Users/seatech/.pub-cache/hosted/pub.dev/firebase_storage-11.7.7/ios/Classes/FLTTaskStateChannelStreamHandler.m
/Users/seatech/.pub-cache/hosted/pub.dev/firebase_storage-11.7.7/ios/Classes/FLTFirebaseStoragePlugin.h
/Users/seatech/.pub-cache/hosted/pub.dev/firebase_storage-11.7.7/ios/Classes/FLTFirebaseStoragePlugin.m
```

Các import sai/có rủi ro:

```objc
#import <Firebase/Firebase.h>
#import <FirebaseStorage/FirebaseStorage.h>
#import <FirebaseStorage/FIRStorageTypedefs.h>
```

được đổi sang:

```objc
@import FirebaseCore;
@import FirebaseStorage;
```

hoặc chỉ:

```objc
@import FirebaseStorage;
```

tùy file có cần `FirebaseCore` hay không.

### 3. Chạy lại CocoaPods

Đã chạy:

```bash
cd ios
pod install
```

Kết quả:

```text
Pod installation complete! There are 10 dependencies from the Podfile and 34 total pods installed.
```

## Checklist nếu lỗi quay lại

1. Đóng Xcode.

2. Xóa DerivedData của Runner:

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
```

3. Chạy lại pods:

```bash
cd ios
pod install
```

4. Mở đúng workspace, không mở project:

```bash
open ios/Runner.xcworkspace
```

5. Kiểm tra import hiện tại:

```bash
rg -n "Firebase/Firebase.h|FirebaseStorage/FirebaseStorage.h|FirebaseStorage/FIRStorageTypedefs.h|@import FirebaseStorage" \
  /Users/seatech/.pub-cache/hosted/pub.dev/firebase_storage-11.7.7/ios/Classes \
  ios/.symlinks/plugins/firebase_storage/ios/Classes \
  ios/Podfile
```

Kỳ vọng là không còn:

```objc
#import <Firebase/Firebase.h>
#import <FirebaseStorage/FirebaseStorage.h>
```

trong `firebase_storage`, mà phải thấy:

```objc
@import FirebaseStorage;
```

## Bài học rút kinh nghiệm

- Khi Xcode báo `file not found` với Firebase iOS, không chỉ kiểm tra package Dart. Cần kiểm tra cả Podfile, Podfile.lock, header path và cách import header.
- Với `use_frameworks!`, tránh include umbrella header non-modular như `Firebase/Firebase.h` bên trong public header của một framework module.
- Không mở/build `ios/Runner.xcodeproj`; luôn dùng `ios/Runner.xcworkspace` để CocoaPods header/framework settings được load.
- Nếu build bị ngắt giữa chừng và báo `build.db is locked`, đóng Xcode, kill build process nếu cần, rồi xóa DerivedData.
- Sửa trong `.pub-cache` chỉ là sửa local. Muốn giữ lại sau `pod install`, cần có patch trong `ios/Podfile`.

