import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:fire_guard/utils/core/mock_data/fire_safety_skills_list.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:fire_guard/view/home/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class FireSafetySkillsScreen extends StatefulWidget {
  const FireSafetySkillsScreen({super.key});
  static const String routeName = '/fireSafetySkillsScreen';

  @override
  _FireSafetySkillsScreenState createState() => _FireSafetySkillsScreenState();
}

class _FireSafetySkillsScreenState extends State<FireSafetySkillsScreen> {
  List<bool> isSelected = [true, false];
  bool isFireSafetySkills = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fire_safety_skills_escape'.tr()),
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
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(30),
                borderWidth: 2,
                fillColor: Colors.orange,
                selectedColor: Colors.white,
                color: Colors.orange,
                constraints: const BoxConstraints(
                  minHeight: 50.0,
                  minWidth: 150.0,
                ),
                children: const <Widget>[
                  Text('Kỹ năng PCCC'),
                  Text('Kỹ năng thoát hiểm'),
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    isFireSafetySkills = index == 0;
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: isFireSafetySkills
                ? const FireSafetySkillsList()
                : const EscapeSkillsList(),
          ),
        ],
      ),
    );
  }
}
