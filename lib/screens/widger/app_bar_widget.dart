import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? number;
  final String route;

  const AppBarWidget({
    super.key,
    required this.title,
    this.number,
    required this.route
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: ColorPalette.colorFFBB35,
      actions: [
        Badge(
          label: Text(number ?? 'n'),
          child: IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, route);
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}