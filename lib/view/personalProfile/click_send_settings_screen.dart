import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';

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
          backgroundColor: Colors.orange,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              _clearData();
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settings.clicksend.name'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'settings.clicksend.enter_name'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'settings.clicksend.name_required'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  'settings.clicksend.key'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _keyController,
                  decoration: InputDecoration(
                    hintText: 'settings.clicksend.enter_key'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'settings.clicksend.key_required'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
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
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'settings.save'.tr(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
