import 'package:fire_guard/utils/core/common/toast.dart';
import 'package:fire_guard/view/widger/LoadingWidget.dart';
import 'package:fire_guard/viewModel/personal_profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // Trạng thái loading
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  // Hàm xử lý logic đổi mật khẩu
  Future<void> _changePassword() async {
    // Lấy giá trị từ các trường nhập liệu
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Kiểm tra mật khẩu mới và xác nhận
    if (newPassword.isEmpty || confirmPassword.isEmpty || oldPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin!')),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu mới không khớp!')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final isChangePassword =
      await Provider.of<PersonalProfileViewModel>(context, listen: false)
          .changePassword(oldPassword: oldPassword, newPassword: newPassword);

      if (isChangePassword) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi xảy ra: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final personalProfileViewModel = Provider.of<PersonalProfileViewModel>(context);
    final model = personalProfileViewModel.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đổi mật khẩu'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thay đổi mật khẩu',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Vui lòng nhập thông tin dưới đây để thay đổi mật khẩu của bạn.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Mật khẩu cũ
                  TextFormField(
                    controller: _oldPasswordController,
                    obscureText: !_showOldPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_showOldPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showOldPassword = !_showOldPassword;
                          });
                        },
                      ),
                      labelText: 'Mật khẩu cũ',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu cũ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Mật khẩu mới
                  TextFormField(
                    controller: _newPasswordController,
                    obscureText: !_showNewPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_reset),
                      suffixIcon: IconButton(
                        icon: Icon(_showNewPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                      ),
                      labelText: 'Mật khẩu mới',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu mới';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Xác nhận mật khẩu mới
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                      labelText: 'Xác nhận mật khẩu mới',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng xác nhận mật khẩu mới';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Nút đổi mật khẩu
                  GradientButton(
                    onPressed: _isLoading ? null : _changePassword,
                    isLoading: _isLoading,
                    text: 'Đổi mật khẩu',
                  ),

                ],
              ),
            ),
          ),
          personalProfileViewModel.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
    );
  }
}



class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          gradient: isLoading
              ? LinearGradient(
            colors: [Colors.grey.shade400, Colors.grey.shade600],
          )
              : const LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (!isLoading)
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
