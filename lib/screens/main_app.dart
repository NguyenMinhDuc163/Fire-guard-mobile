import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/home_screen/views/home_screen.dart';
import 'package:fire_guard/screens/profile_screen/providers/persional_profile_view_model.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:fire_guard/utils/core/helpers/asset_helper.dart';
import 'package:fire_guard/screens/fire_news_screen/views/fire_news_screen.dart';
import 'package:fire_guard/screens/fire_safety_skills_screen/views/fire_safety_skills_screen.dart';
import 'package:fire_guard/screens/fire_news_screen/providers/fire_news_view_model.dart';
import 'package:fire_guard/screens/fire_safety_skills_screen/providers/fire_safety_skills_view_model.dart';
import 'package:fire_guard/screens/home_screen/providers/home_view_model.dart';
import 'package:fire_guard/service/service_config/notification_service.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'profile_screen/views/personal_profile_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  static const String routeName = '/main_app';
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static const String _safetyDisclaimerAcceptedKey = 'safetyDisclaimerAccepted';

  int _selectedIndex = 0; // Chỉ số của trang hiện tạixl

  // Danh sách các màn hình tương ứng với mỗi mục trong BottomNavigationBar
  // static const List<Widget> _widgetOptions = <Widget>[
  //   HomeScreen(),        // Trang "Trang chủ"// Trang "Trang chủ"
  //   FireNewsScreen(),    // Trang "Tin PCCC"
  //   FireSafetySkillsScreen(),  // Trang "Kỹ năng PCCC"
  //   PersonalProfileScreen(),   // Trang "Cá nhân"
  // ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runStartupPermissionFlow();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Cập nhật chỉ số khi người dùng chọn trang
    });
  }

  Future<void> _runStartupPermissionFlow() async {
    await _showSafetyDisclaimerIfNeeded();
    if (!mounted) return;
    await _showNotificationPermissionIfNeeded();
  }

  Future<void> _showSafetyDisclaimerIfNeeded() async {
    final isAccepted =
        LocalStorageHelper.getValue(_safetyDisclaimerAcceptedKey) == true;
    if (isAccepted || !mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('safety_disclaimer.title'.tr()),
          content: SingleChildScrollView(
            child: Text('safety_disclaimer.body'.tr()),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                LocalStorageHelper.setValue(
                  _safetyDisclaimerAcceptedKey,
                  true,
                );
                Navigator.of(dialogContext).pop();
              },
              child: Text('safety_disclaimer.understood'.tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNotificationPermissionIfNeeded() async {
    final notificationService = NotificationService();
    final shouldAsk =
        await notificationService.isNotificationPermissionNotDetermined();
    if (!shouldAsk) {
      await notificationService.requestPermissionAndSaveToken();
      return;
    }

    if (!mounted) return;

    final shouldRequest = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('permissions.notification_title'.tr()),
          content: Text('permissions.notification_body'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('permissions.not_now'.tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('permissions.allow'.tr()),
            ),
          ],
        );
      },
    );

    if (shouldRequest == true) {
      await notificationService.requestPermissionAndSaveToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final widgetOptions = <Widget>[
      ChangeNotifierProvider<HomeViewModel>(
        key: ValueKey('home_${locale.toString()}'),
        create: (_) => HomeViewModel(),
        child: const HomeScreen(),
      ),
      ChangeNotifierProvider<FireNewsViewModel>(
        key: ValueKey('news_${locale.toString()}'),
        create: (_) => FireNewsViewModel(),
        child: const FireNewsScreen(),
      ),
      ChangeNotifierProvider<FireSafetySkillsViewModel>(
        key: ValueKey('skills_${locale.toString()}'),
        create: (_) => FireSafetySkillsViewModel(),
        child: const FireSafetySkillsScreen(),
      ),
      ChangeNotifierProvider<PersonalProfileViewModel>(
        key: ValueKey('profile_${locale.toString()}'),
        create: (_) => PersonalProfileViewModel(),
        child: const PersonalProfileScreen(),
      ),
    ];

    return Scaffold(
      body: widgetOptions[
          _selectedIndex], // Hiển thị màn hình tương ứng với chỉ số hiện tại
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AssetHelper.icoHome),
            label: 'home_screen.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AssetHelper.quizzes),
            label: 'home_screen.fireNews'.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AssetHelper.leaderboard),
            label: 'home_screen.fireSafetySkills'.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(AssetHelper.friends),
            label: 'home_screen.personalProfile'.tr(),
          ),
        ],
        selectedItemColor: Colors.orange, // Màu sắc khi item được chọn
        unselectedItemColor: Colors.grey, // Màu sắc khi item không được chọn
        backgroundColor:
            ColorPalette.kLightPink2, // Màu nền của thanh điều hướng
        onTap: _onItemTapped, // Sự kiện khi người dùng nhấn vào item
      ),
    );
  }
}
