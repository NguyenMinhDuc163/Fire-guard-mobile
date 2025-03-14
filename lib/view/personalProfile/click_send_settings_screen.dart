import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';

class ClickSendSettingsScreen extends StatefulWidget {
  final Function(String name, String key) onSave;

  const ClickSendSettingsScreen({
    super.key,
    required this.onSave,
  });

  @override
  State<ClickSendSettingsScreen> createState() =>
      _ClickSendSettingsScreenState();
}

class _ClickSendSettingsScreenState extends State<ClickSendSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _keyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final name = LocalStorageHelper.getValue('clickSendName');
    final key = LocalStorageHelper.getValue('clickSendKey');

    if (name != null) _nameController.text = name;
    if (key != null) _keyController.text = key;
  }

  void _clearData() {
    _nameController.clear();
    _keyController.clear();
  }

  @override
  void dispose() {
    _clearData();
    _nameController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: ColorPalette.colorFFBB35, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _clearData();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('settings.clicksend.title'.tr()),
          backgroundColor: ColorPalette.colorFFBB35,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _clearData();
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    label: 'settings.clicksend.name'.tr(),
                    hint: 'settings.clicksend.enter_name'.tr(),
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'settings.clicksend.name_required'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    label: 'settings.clicksend.key'.tr(),
                    hint: 'settings.clicksend.enter_key'.tr(),
                    controller: _keyController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'settings.clicksend.key_required'.tr();
                      }
                      return null;
                    },
                    isPassword: true,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave(
                            _nameController.text,
                            _keyController.text,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPalette.colorFFBB35,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'settings.save'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
