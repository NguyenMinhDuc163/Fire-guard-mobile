import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import 'package:fire_guard/utils/router_names.dart';
import 'package:fire_guard/view/home/widget/drawer_widget.dart';
import 'package:fire_guard/viewModel/fire_safety_skills_view_model.dart';
import 'package:fire_guard/view/fireSafetySkills/skill_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<FireSafetySkillsViewModel>(context, listen: false);
      viewModel.fetchFireSafetySkills();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fire_safety_skills_escape'.tr()),
        backgroundColor: ColorPalette.colorFFBB35,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
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
                children: [
                  Text('fire_safety_skills.fire_safety'.tr()),
                  Text('fire_safety_skills.escape'.tr()),
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    isFireSafetySkills = index == 0;
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                  final viewModel = Provider.of<FireSafetySkillsViewModel>(
                      context,
                      listen: false);
                  if (index == 0) {
                    viewModel.fetchFireSafetySkills();
                  } else {
                    viewModel.fetchEscapeSkills();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<FireSafetySkillsViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text('fire_safety_skills.loading'.tr()),
                      ],
                    ),
                  );
                }

                if (viewModel.error != null) {
                  return Center(
                    child: Text(
                      'fire_safety_skills.error'.tr(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final items = isFireSafetySkills
                    ? viewModel.fireSafetySkills
                    : viewModel.escapeSkills;

                if (items.isEmpty) {
                  return Center(
                    child: Text('fire_safety_skills.no_data'.tr()),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return SkillItem(
                      number: item.type ?? '',
                      title: item.title ?? '',
                      content: item.content ?? '',
                      imageUrl: item.url ?? '',
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
