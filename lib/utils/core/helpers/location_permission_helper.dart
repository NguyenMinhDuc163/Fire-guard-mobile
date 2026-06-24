import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionHelper {
  LocationPermissionHelper._();

  static Future<bool> ensureWhenInUsePermission(BuildContext context) async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('location.service_disabled'.tr())),
        );
      }
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        await _showOpenSettingsDialog(context);
      }
      return false;
    }

    if (permission == LocationPermission.denied) {
      final shouldRequest =
          context.mounted ? await _showLocationRationaleDialog(context) : false;
      if (!shouldRequest) return false;

      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<bool> _showLocationRationaleDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('permissions.location_title'.tr()),
          content: Text('permissions.location_body'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('permissions.allow'.tr()),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  static Future<void> _showOpenSettingsDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('permissions.location_denied_title'.tr()),
          content: Text('permissions.location_denied_body'.tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('common.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Geolocator.openAppSettings();
              },
              child: Text('permissions.open_settings'.tr()),
            ),
          ],
        );
      },
    );
  }
}
