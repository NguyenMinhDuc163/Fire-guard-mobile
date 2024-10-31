import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:fire_guard/utils/core/helpers/asset_helper.dart';
import 'package:fire_guard/view/fireNews/fire_news_screen.dart';
import 'package:fire_guard/view/fireSafetySkills/fire_safety_skills_screen.dart';
import 'package:fire_guard/viewModel/fire_news_view_model.dart';
import 'package:fire_guard/viewModel/fire_safety_skill_view_model.dart';
import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:fire_guard/viewModel/personal_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_guard/view/home/home_screen.dart';
import 'package:provider/provider.dart';

import 'personalProfile/personal_profile_screen.dart';  // Đảm bảo rằng bạn đã tạo HomeScreen và các màn hình khác

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;  // Chỉ số của trang hiện tạixl

  // Danh sách các màn hình tương ứng với mỗi mục trong BottomNavigationBar
  // static const List<Widget> _widgetOptions = <Widget>[
  //   HomeScreen(),        // Trang "Trang chủ"// Trang "Trang chủ"
  //   FireNewsScreen(),    // Trang "Tin PCCC"
  //   FireSafetySkillsScreen(),  // Trang "Kỹ năng PCCC"
  //   PersonalProfileScreen(),   // Trang "Cá nhân"
  // ];

  static final List<Widget> _widgetOptions = <Widget>[
    ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
      child: const HomeScreen(),
    ),
    ChangeNotifierProvider<FireNewsViewModel>(
      create: (_) => FireNewsViewModel(),
      child: const FireNewsScreen(),
    ),
    ChangeNotifierProvider<FireSafetySkillViewModel>(
      create: (_) => FireSafetySkillViewModel(),
      child: const FireSafetySkillsScreen(),
    ),
    ChangeNotifierProvider<PersonalProfileViewModel>(
      create: (_) => PersonalProfileViewModel(),
      child: const PersonalProfileScreen(),
    ),
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
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
