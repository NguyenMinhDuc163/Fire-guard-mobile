import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../init.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorPalette.colorFFBB35,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              // Thêm hành động điều hướng khi ấn vào menu
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text('registered_location'.tr()),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.registerCoordinatesScreen);
              // Thêm hành động điều hướng khi ấn vào menu
            },
          ),
          ListTile(
            leading: Icon(Icons.family_restroom),
            title: Text('manage_family_members'.tr()),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.familyManagementScreen);
              // Thêm hành động điều hướng khi ấn vào menu
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.policy),
          //   title: Text('privacy_policy'.tr()),
          //   onTap: () {
          //     Navigator.pop(context);
          //     // Thêm hành động điều hướng khi ấn vào menu
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('setting'.tr()),
            onTap: () {
              Navigator.pushNamed(context, RouteNames.settings);
              // Thêm hành động điều hướng khi ấn vào menu
            },
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text('about'.tr()),
            onTap: () async {
              final Uri url = Uri.parse('https://github.com/NguyenMinhDuc163/Fire-guard-mobile/blob/main/README.md');
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              throw 'Could not launch URL}';
              }
              Navigator.pop(context);
              // Thêm hành động điều hướng khi ấn vào menu
            },
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text('logout'.tr()),
            onTap: () async {
              LocalStorageHelper.deleteValue('userName');
              LocalStorageHelper.deleteValue('email');

              // Điều hướng về màn hình đăng nhập và xóa tất cả các route trước đó
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteNames.loginScreen, // Tên route của màn hình đăng nhập
                    (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
              );

              // Thêm hành động điều hướng khi ấn vào menu
            },
          ),
        ],
      ),
    );
  }
}
