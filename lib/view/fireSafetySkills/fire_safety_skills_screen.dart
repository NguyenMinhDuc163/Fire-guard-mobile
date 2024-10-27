import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
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
        title:  Text('fire_safety_skills_escape'.tr()),
        backgroundColor: ColorPalette.colorFFBB35,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Hành động khi ấn vào nút thông báo
              print('Notification button pressed');
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

class FireSafetySkillsList extends StatelessWidget {
  const FireSafetySkillsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        SkillItem(number: '1', description: 'Kỹ năng cần thiết người dân cần trang bị để xử lý khi có cháy'),
        SkillItem(number: '2', description: 'Cách phòng ngừa cháy nổ từ máy sấy quần áo'),
        SkillItem(number: '3', description: 'Cách bảo đảm an toàn PCCC dịp Tết Nguyên đán'),
        SkillItem(number: '4', description: 'Kỹ năng an toàn PCCC khi sạc điện thoại, laptop, xe đạp điện...'),
        SkillItem(number: '5', description: 'Hướng dẫn kỹ năng sử dụng điện an toàn trong gia đình'),
        SkillItem(number: '6', description: 'Hướng dẫn xử lý khi phát hiện rò rỉ khí gas'),
        SkillItem(number: '7', description: 'Các biện pháp đảm bảo an toàn Phòng cháy và chữa cháy rừng'),
      ],
    );
  }
}

class EscapeSkillsList extends StatelessWidget {
  const EscapeSkillsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        SkillItem(number: '1', description: 'Kỹ năng thoát hiểm khi có hỏa hoạn trong nhà cao tầng'),
        SkillItem(number: '2', description: 'Cách sử dụng thang thoát hiểm an toàn'),
        SkillItem(number: '3', description: 'Kỹ năng thoát hiểm khi gặp cháy trong xe ô tô'),
        SkillItem(number: '4', description: 'Cách nhận biết tín hiệu nguy hiểm và các đường thoát hiểm'),
        SkillItem(number: '5', description: 'Kỹ năng thoát hiểm trong môi trường nhiều khói'),
      ],
    );
  }
}

class SkillItem extends StatelessWidget {
  final String number;
  final String description;

  const SkillItem({required this.number, required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(number),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        title: Text(description),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: FireSafetySkillsScreen(),
  ));
}
