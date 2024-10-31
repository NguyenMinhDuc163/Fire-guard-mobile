import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
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
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: Colors.grey),
            title: const Text('Bật chế độ Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
              // Thêm logic để bật/tắt Dark Mode (nếu có)
            },
          ),
          const Divider(),

          // Đổi mật khẩu
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.red),
            title: const Text('Đổi mật khẩu'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsDetailScreen(
                    title: 'Đổi mật khẩu',
                    hintText: 'Nhập mật khẩu mới',
                    inputType: TextInputType.visiblePassword,
                  ),
                ),
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
          title: const Text('Chọn ngôn ngữ'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Tiếng Việt'),
                value: 'Tiếng Việt',
                groupValue: currentLanguage,
                onChanged: (value) {
                  setState(() {
                    currentLanguage = value!;
                    context.setLocale(const Locale('vi', 'VN'));
                    LocalStorageHelper.setValue('languageCode', 'vi');
                  });
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: currentLanguage,
                onChanged: (value) {
                  setState(() {
                    currentLanguage = value!;
                    context.setLocale(const Locale('en', 'US'));
                    LocalStorageHelper.setValue('languageCode', 'en');
                  });
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
