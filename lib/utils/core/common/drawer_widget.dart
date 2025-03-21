import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/screens/authen_screen/provider/auth_view_model.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fire_guard/utils/core/helpers/asset_helper.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';

import '../../../init.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: ColorPalette.colorFFBB35,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(AssetHelper.avatar),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    LocalStorageHelper.getValue('userName') ??
                        '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    LocalStorageHelper.getValue('email') ??
                        '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildDrawerItem(
              icon: Icons.home,
              title: 'home_screen.home'.tr(),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildDrawerItem(
              icon: Icons.location_on_outlined,
              title: 'drawer.registered_location'.tr(),
              onTap: () {
                Navigator.pushNamed(
                    context, RouteNames.registerCoordinatesScreen);
              },
            ),
            _buildDrawerItem(
              icon: Icons.family_restroom,
              title: 'drawer.manage_family_members'.tr(),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.familyManagementScreen);
              },
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'drawer.setting'.tr(),
              onTap: () {
                Navigator.pushNamed(context, RouteNames.settings);
              },
            ),
            _buildDrawerItem(
              icon: Icons.info_outline,
              title: 'drawer.about'.tr(),
              onTap: () async {
                final Uri url = Uri.parse(
                    'https://github.com/NguyenMinhDuc163/Fire-guard-mobile/blob/main/README.md');
                if (!await launchUrl(url,
                    mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch URL}';
                }
                Navigator.pop(context);
              },
            ),
            const Divider(height: 1),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'drawer.logout'.tr(),
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () async {
                LocalStorageHelper.deleteValue('ignoreIntroScreen');
                LocalStorageHelper.deleteValue('userName');
                LocalStorageHelper.deleteValue('email');
                LocalStorageHelper.deleteValue('authToken');
                AuthViewModel authViewModel = AuthViewModel();
                authViewModel.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.loginScreen,
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Colors.grey[700],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.grey[700],
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      dense: true,
    );
  }
}
