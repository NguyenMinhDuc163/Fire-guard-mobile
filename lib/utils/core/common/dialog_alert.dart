import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/constants/dimension_constants.dart';
import 'package:flutter/material.dart';

class DialogAlert{
  static showTimeoutDialog({required String tile, required String content}) {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title:  Text(tile),
        content:  Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child:  Text('ok'.tr()),
          ),
        ],
      ),
    );
  }
}