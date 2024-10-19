import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fire_guard/view/home/widget/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../init.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      appBar: AppBar(
        title: const Text('Fire Guard'),
        backgroundColor: ColorPalette.colorFFBB35,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Hành động khi ấn vào nút thông báo
              print('Notification button pressed');
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          Image.asset(
            AssetHelper.backgroundHome,
            fit: BoxFit.cover,
            width: double.infinity,  // Đảm bảo ảnh phủ kín chiều ngang
            height: double.infinity, // Đảm bảo ảnh phủ kín chiều dọc
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width_8, vertical: height_20),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Hành động khi nút được bấm
                      print('Báo cháy button pressed');
                    },
                    child: Container(
                      width: width_200,  // Kích thước chiều rộng của nút
                      height: height_200, // Kích thước chiều cao của nút
                      decoration: BoxDecoration(
                        color: ColorPalette.colorRed,  // Màu nền của nút
                        shape: BoxShape.circle,  // Hình dạng là hình tròn
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),  // Độ mờ và bóng của nút
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AssetHelper.icoFireAlarm, width: width_56, height: height_56,),  // Thêm icon báo động
                          const SizedBox(height: 10),
                          Text(
                            'fireAlarm'.tr(),
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text(
                            'atYourLocation'.tr(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height_20),

                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),  // Màu nền với độ trong suốt
                    borderRadius: BorderRadius.circular(20.0),  // Bo góc các cạnh
                  ),
                  child: Text(
                    'fireWarningMessage'.tr(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,  // Màu chữ
                    ),
                    textAlign: TextAlign.center,  // Căn giữa văn bản
                  ),
                ),
                SizedBox(height: height_20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nút Gọi 114
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final Uri phoneUri = Uri(scheme: 'tel', path: '114'); // Thay bằng số điện thoại của bạn

                          if (await canLaunchUrl(phoneUri)) {
                            await launchUrl(phoneUri);
                          } else {
                            throw 'Could not launch $phoneUri';
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          width: 150,  // Chiều rộng của mỗi nút
                          height: 100, // Chiều cao của mỗi nút
                          decoration: BoxDecoration(
                            color: Colors.white,  // Màu nền của nút
                            borderRadius: BorderRadius.circular(20.0),  // Bo góc
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),  // Đổ bóng nhẹ
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2),  // Vị trí của bóng
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: Colors.orange, size: 30),  // Icon Gọi 114
                              SizedBox(height: 10),
                              Text(
                                'call114'.tr(),
                                style: TextStyle(color: Colors.orange, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width_20),
                    // Nút Xem và Thông báo vị trí đám cháy
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Hành động khi nhấn vào nút Thông báo vị trí đám cháy
                          print('Xem và Thông báo vị trí đám cháy pressed');
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: height_8),
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child:  const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, color: Colors.orange, size: 30),  // Icon bản đồ
                              SizedBox(height: 10),
                              Text(
                                'Xem và Thông báo vị trí đám cháy',
                                style: TextStyle(color: Colors.orange, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
