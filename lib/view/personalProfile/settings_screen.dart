import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/view/personalProfile/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Thư viện đổi ngôn ngữ
import 'package:provider/provider.dart';
import 'package:fire_guard/viewModel/setting_view_model.dart';
import 'settings_detail_screen.dart'; // Import màn hình chi tiết
import 'click_send_settings_screen.dart'; // Import màn hình cài đặt ClickSend

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const String routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isVietnamese = true;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _initializeLanguage();
  }

  void _initializeLanguage() {
    String? savedLocale = LocalStorageHelper.getValue('languageCode');
    if (savedLocale != null) {
      isVietnamese = savedLocale == 'vi';
    }
  }

  void _changeLanguage() async {
    setState(() {
      isVietnamese = !isVietnamese;
      if (isVietnamese) {
        context.setLocale(const Locale('vi', 'VN'));
        LocalStorageHelper.setValue('languageCode', 'vi');
      } else {
        context.setLocale(const Locale('en', 'US'));
        LocalStorageHelper.setValue('languageCode', 'en');
      }
    });

    // Đợi một chút để đảm bảo locale được cập nhật
    await Future.delayed(const Duration(milliseconds: 100));

    // Cập nhật lại toàn bộ widget tree
    if (mounted) {
      setState(() {});
    }
  }

  void _showMessage(String message, Color color) {
    _scaffoldKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _handleUpdateEmail(BuildContext context, String newEmail) async {
    final viewModel = context.read<SettingViewModel>();
    final success = await viewModel.updateEmail(newEmail);

    if (!mounted) return;

    final message = success
        ? 'Email đã được cập nhật thành công'
        : viewModel.error ?? 'Có lỗi xảy ra khi cập nhật email';
    final color = success ? Colors.green : Colors.red;

    _showMessage(message, color);
  }

  Future<void> _handleUpdatePhone(BuildContext context, String newPhone) async {
    final viewModel = context.read<SettingViewModel>();
    final success = await viewModel.updatePhone(newPhone);

    if (!mounted) return;

    final message = success
        ? 'Số điện thoại đã được cập nhật thành công'
        : viewModel.error ?? 'Có lỗi xảy ra khi cập nhật số điện thoại';
    final color = success ? Colors.green : Colors.red;

    _showMessage(message, color);
  }

  Future<void> _handleUpdateClickSend(
      BuildContext context, String name, String key) async {
    final viewModel = context.read<SettingViewModel>();
    final success = await viewModel.updateClickSendInfo(
      name: name,
      key: key,
    );

    if (!mounted) return;

    final message = success
        ? 'Thông tin ClickSend đã được cập nhật thành công'
        : viewModel.error ?? 'Có lỗi xảy ra khi cập nhật thông tin ClickSend';
    final color = success ? Colors.green : Colors.red;

    _showMessage(message, color);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('settings.title'.tr()),
          backgroundColor: Colors.orange,
        ),
        body: Consumer<SettingViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Thay đổi ngôn ngữ
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.blue),
                  title: Text('settings.change_language'.tr()),
                  subtitle: Text(isVietnamese ? 'Tiếng Việt' : 'English'),
                  onTap: _changeLanguage,
                ),
                const Divider(),

                // Đổi mật khẩu
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.red),
                  title: Text('settings.change_password'.tr()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                ),

                const Divider(),

                // Thay đổi email
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.purple),
                  title: Text('settings.change_email'.tr()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsDetailScreen(
                          title: 'settings.change_email'.tr(),
                          hintText: 'settings.enter_new_email'.tr(),
                          inputType: TextInputType.emailAddress,
                          onSave: (value) => _handleUpdateEmail(context, value),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),

                // Thay đổi số điện thoại
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.green),
                  title: Text('settings.change_phone'.tr()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsDetailScreen(
                          title: 'settings.change_phone'.tr(),
                          hintText: 'settings.enter_new_phone'.tr(),
                          inputType: TextInputType.phone,
                          onSave: (value) => _handleUpdatePhone(context, value),
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),

                // Cài đặt ClickSend
                ListTile(
                  leading: const Icon(Icons.notifications_active,
                      color: Colors.indigo),
                  title: Text('settings.clicksend.title'.tr()),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClickSendSettingsScreen(
                          onSave: (name, key) =>
                              _handleUpdateClickSend(context, name, key),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
