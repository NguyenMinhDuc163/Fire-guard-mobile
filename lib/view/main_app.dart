import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fire_guard/res/core/constants/color_constants.dart';
import 'package:fire_guard/res/core/helpers/asset_helper.dart';
import 'package:fire_guard/view/home/home_screen.dart';


class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: HomeScreen(),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        key: _bottomNavigationKey,
        index: 2,
        items:  [
          CurvedNavigationBarItem(
            child: SvgPicture.asset(AssetHelper.icoHome),
            label: 'home'.tr(),
          ),
          CurvedNavigationBarItem(
            child: SvgPicture.asset(AssetHelper.quizzes),
            label: 'quizzes'.tr(),
          ),
          const CurvedNavigationBarItem(
            child: Icon(FontAwesomeIcons.plus),
          ),
          CurvedNavigationBarItem(
            child: SvgPicture.asset(AssetHelper.leaderboard),
            label: 'leaderboard'.tr(),
          ),
          CurvedNavigationBarItem(
            child: SvgPicture.asset(AssetHelper.friends),
            label:'friends'.tr(),
          ),
        ],
        color: ColorPalette.darkSlateGray,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.red.shade200,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}