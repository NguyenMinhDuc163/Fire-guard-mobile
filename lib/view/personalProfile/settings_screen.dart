import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/view/personalProfile/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Thư viện đổi ngôn ngữ
import 'settings_detail_screen.dart'; // Import màn hình chi tiết

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const String routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // Trạng thái Dark Mode
  String currentLanguage = 'Tiếng Việt'; // Ngôn ngữ hiện tại

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái ngôn ngữ từ giá trị lưu trữ
    _initializeLanguage();
  }

  // Hàm khởi tạo ngôn ngữ từ LocalStorage
  void _initializeLanguage() {
    String languageCode = LocalStorageHelper.getValue('languageCode') ?? 'vi';
    setState(() {
      currentLanguage = (languageCode == 'vi') ? 'Tiếng Việt' : 'English';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài Đặt'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Thay đổi ngôn ngữ
          ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: const Text('Thay đổi ngôn ngữ'),
            subtitle: Text(currentLanguage),
            onTap: _showLanguageDialog,
          ),
          const Divider(),

          // Bật Dark Mode

          // Đổi mật khẩu
          // Đổi mật khẩu
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.red),
            title: const Text('Đổi mật khẩu'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            },
          ),

          const Divider(),

          // Thay đổi email
          ListTile(
            leading: const Icon(Icons.email, color: Colors.purple),
            title: const Text('Thay đổi email'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsDetailScreen(
                    title: 'Thay đổi email',
                    hintText: 'Nhập email mới',
                    inputType: TextInputType.emailAddress,
                  ),
                ),
              );
            },
          ),
          const Divider(),

          // Thay đổi số điện thoại
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: const Text('Thay đổi số điện thoại'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsDetailScreen(
                    title: 'Thay đổi số điện thoại',
                    hintText: 'Nhập số điện thoại mới',
                    inputType: TextInputType.phone,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Hàm hiển thị hộp thoại chọn ngôn ngữ
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select_language'.tr()), // Từ khóa dịch
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text('vietnamese'.tr()),
                value: 'vi',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('vi', 'VN')); // Cập nhật locale
                  LocalStorageHelper.setValue('languageCode', 'vi'); // Lưu trạng thái
                  setState(() {}); // Cập nhật UI ngay lập tức
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: Text('english'.tr()),
                value: 'en',
                groupValue: context.locale.languageCode,
                onChanged: (value) {
                  context.setLocale(const Locale('en', 'US'));
                  LocalStorageHelper.setValue('languageCode', 'en');
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }


}
