import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/fire_map_screen/views/fire_alert_map_screen.dart';
import 'package:fire_guard/screens/home_screen/views/notification_screen.dart';
import 'package:fire_guard/screens/widger/LoadingWidget.dart';
import 'package:fire_guard/screens/widger/app_bar_widget.dart';
import 'package:fire_guard/utils/core/common/drawer_widget.dart';
import 'package:fire_guard/screens/home_screen/providers/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../init.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home_screen';
  @override
  Widget build(BuildContext context) {

    final homeViewModel = Provider.of<HomeViewModel>(context);
    final model = homeViewModel.model;

    return Scaffold(
      backgroundColor: ColorPalette.backgroundScaffoldColor,
      appBar: AppBarWidget(title: 'home_screen.app_title'.tr(), route: NotificationsScreen.routeName),
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
                    onTap: () async {
                     bool isSend = await homeViewModel.sendNotification();
                      if(isSend){
                        showToast(message: 'home_screen.send_alert_success'.tr(),);
                      }else{
                        showToast(message: 'home_screen.send_alert_failure'.tr(),);
                      }
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
                          Image.asset(AssetHelper.icoFireAlarm, width: width_56, height: height_56,),
                          const SizedBox(height: 10),
                          Text(
                            'home_screen.fireAlarm'.tr(),
                            style: const TextStyle(color: Colors.white, fontSize: 24),
                          ),
                          Text(
                            'home_screen.atYourLocation'.tr(),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
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
                    'home_screen.fireWarningMessage'.tr(),
                    style: const TextStyle(
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
                          int? isCall = await homeViewModel.sendFireEmergency();
                          if(isCall == 200){
                            showToast(message: 'home_screen.send_alert_success'.tr(),);
                          }else if(isCall == 429){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('home_screen.notification'.tr()),
                                  content:  Text(
                                    'home_screen.wait_before_next_alert'.tr(),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ElevatedButton(
                                          onPressed:  homeViewModel.directCall,
                                          child: Text('home_screen.call_now'.tr()),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // Đóng popup
                                          },
                                          child: Text('common.cancel'.tr()),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );

                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          width: width_250,  // Chiều rộng của nút
                          height: height_85, // Chiều cao của nút
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
                              Icon(Icons.phone, color: Colors.orange, size: 30),  // Icon Gọi
                              SizedBox(height: 10),
                              Text(
                                'home_screen.call114'.tr(),
                                style: TextStyle(color: Colors.orange, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                      ,
                    ),
                    SizedBox(width: width_20),
                    // Nút Xem và Thông báo vị trí đám cháy
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Hành động khi nhấn vào nút Thông báo vị trí đám cháy
                          Navigator.pushNamed(context, FireAlertMapScreen.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: height_8, horizontal: width_16),
                          width: width_250,
                          height: height_85,
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
                          child:   Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.map, color: Colors.orange, size: 30),  // Icon bản đồ
                              const SizedBox(height: 10),
                              Text(
                                'home_screen.view_and_report_fire'.tr(),
                                style: const TextStyle(color: Colors.orange, fontSize: 14),
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
          ),
          homeViewModel.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
    );
  }
}
