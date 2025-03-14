import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/view/personalProfile/change_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Thư viện đổi ngôn ngữ
import 'package:provider/provider.dart';
import 'package:fire_guard/viewModel/setting_view_model.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
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
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    Color? iconColor,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (iconColor ?? Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor ?? Colors.blue,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              )
            : null,
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('settings.title'.tr()),
          backgroundColor: ColorPalette.colorFFBB35,
          elevation: 0,
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

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorPalette.colorFFBB35.withOpacity(0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSettingCard(
                    icon: Icons.language,
                    title: 'settings.change_language'.tr(),
                    subtitle: isVietnamese ? 'Tiếng Việt' : 'English',
                    onTap: _changeLanguage,
                    iconColor: Colors.blue,
                  ),
                  _buildSettingCard(
                    icon: Icons.lock,
                    title: 'settings.change_password'.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                    iconColor: Colors.red,
                  ),
                  _buildSettingCard(
                    icon: Icons.email,
                    title: 'settings.change_email'.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsDetailScreen(
                            title: 'settings.change_email'.tr(),
                            hintText: 'settings.enter_new_email'.tr(),
                            inputType: TextInputType.emailAddress,
                            onSave: (value) =>
                                _handleUpdateEmail(context, value),
                          ),
                        ),
                      );
                    },
                    iconColor: Colors.purple,
                  ),
                  _buildSettingCard(
                    icon: Icons.phone,
                    title: 'settings.change_phone'.tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsDetailScreen(
                            title: 'settings.change_phone'.tr(),
                            hintText: 'settings.enter_new_phone'.tr(),
                            inputType: TextInputType.phone,
                            onSave: (value) =>
                                _handleUpdatePhone(context, value),
                          ),
                        ),
                      );
                    },
                    iconColor: Colors.green,
                  ),
                  _buildSettingCard(
                    icon: Icons.notifications_active,
                    title: 'settings.clicksend.title'.tr(),
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
                    iconColor: Colors.indigo,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
