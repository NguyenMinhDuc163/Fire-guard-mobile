import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_guard/res/core/constants/color_constants.dart';
import 'package:fire_guard/res/core/helpers/asset_helper.dart';
import 'package:fire_guard/view/home/home_screen.dart';  // Đảm bảo rằng bạn đã tạo HomeScreen và các màn hình khác

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;  // Chỉ số của trang hiện tạixl

  // Danh sách các màn hình tương ứng với mỗi mục trong BottomNavigationBar
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),        // Trang "Trang chủ"
    HomeScreen(),        // Trang "Trang chủ"
    HomeScreen(),        // Trang "Trang chủ"
    HomeScreen(),        // Trang "Trang chủ"
    // FireNewsScreen(),    // Trang "Tin PCCC"
    // FireSafetySkillsScreen(),  // Trang "Kỹ năng PCCC"
    // PersonalProfileScreen(),   // Trang "Cá nhân"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Cập nhật chỉ số khi người dùng chọn trang
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],  // Hiển thị màn hình tương ứng với chỉ số hiện tại
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),  // Bo góc trái trên
          topRight: Radius.circular(30.0), // Bo góc phải trên
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetHelper.icoHome),
              label: 'home'.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetHelper.quizzes),
              label: 'fireNews'.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetHelper.leaderboard),
              label: 'fireSafetySkills'.tr(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(AssetHelper.friends),
              label: 'personalProfile'.tr(),
            ),
          ],
          selectedItemColor: Colors.orange,  // Màu sắc khi item được chọn
          unselectedItemColor: Colors.grey,  // Màu sắc khi item không được chọn
          backgroundColor: ColorPalette.kLightPink2,  // Màu nền của thanh điều hướng
          onTap: _onItemTapped,  // Sự kiện khi người dùng nhấn vào item
        ),
      ),
    );
  }
}
