import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:fire_guard/utils/core/constants/dimension_constants.dart';
import 'package:fire_guard/utils/core/mock_data/fire_news_list.dart';
import 'package:fire_guard/utils/core/mock_data/good_people_stories_list.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:fire_guard/view/home/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class FireNewsScreen extends StatefulWidget {
  const FireNewsScreen({super.key});
  static const String routeName = '/fireNewsScreen';

  @override
  State<FireNewsScreen> createState() => _FireNewsScreenState();
}

class _FireNewsScreenState extends State<FireNewsScreen> {
  bool isFireNews = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fire_news'.tr()),
        backgroundColor: ColorPalette.colorFFBB35,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.notifications);
            },
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: height_16),
            child: Center(
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                borderWidth: 2,
                fillColor: Colors.orange,
                selectedColor: Colors.white,
                color: Colors.orange,
                constraints: const BoxConstraints(
                  minHeight: 50.0,
                  minWidth: 120.0,
                ),
                children: const <Widget>[
                  Text('Tin tức cháy nổ'),
                  Text('Người tốt việc tốt'),
                ],
                isSelected: [isFireNews, !isFireNews],
                onPressed: (int index) {
                  setState(() {
                    isFireNews = index == 0;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: isFireNews
                ?  FireNewsList() // Hiển thị danh sách tin tức cháy nổ
                :  GoodPeopleStoriesList(), // Hiển thị danh sách người tốt việc tốt
          ),
        ],
      ),
    );
  }
}
