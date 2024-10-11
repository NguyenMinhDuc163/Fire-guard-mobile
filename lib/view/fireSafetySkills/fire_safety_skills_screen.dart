import 'package:flutter/material.dart';

class FireSafetySkillsScreen extends StatefulWidget {
  const FireSafetySkillsScreen({super.key});
  @override
  _FireSafetySkillsScreenState createState() => _FireSafetySkillsScreenState();
}

class _FireSafetySkillsScreenState extends State<FireSafetySkillsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kỹ năng PCCC & Thoát hiểm'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.settings),
              text: 'Kỹ năng PCCC',
            ),
            Tab(
              icon: Icon(Icons.directions_run),
              text: 'Kỹ năng thoát hiểm',
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.orange,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(30), // Bo tròn góc
            color: Colors.orange, // Màu của tab đang được chọn
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FireSafetySkillsList(),
          EscapeSkillsList(),
        ],
      ),
    );
  }
}

class FireSafetySkillsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
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
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
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

  SkillItem({required this.number, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
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
  runApp(MaterialApp(
    home: FireSafetySkillsScreen(),
  ));
}
