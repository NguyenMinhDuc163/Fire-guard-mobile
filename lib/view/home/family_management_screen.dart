import 'package:flutter/material.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});
  static const String routeName = '/family_management';
  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  List<Map<String, String>> familyMembers = [
    {'name': 'Nguyễn Văn A', 'contact': '0123456789', 'status': 'Đã nhận thông báo'},
    {'name': 'Trần Thị B', 'contact': 'username_b', 'status': 'Chưa nhận thông báo'},
  ];

  void _addFamilyMember() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        String contact = '';
        return AlertDialog(
          title: const Text('Thêm Người Thân'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Tên người thân'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Số điện thoại hoặc username'),
                onChanged: (value) {
                  contact = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.isNotEmpty && contact.isNotEmpty) {
                  setState(() {
                    familyMembers.add({
                      'name': name,
                      'contact': contact,
                      'status': 'Chưa nhận thông báo',
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void _deleteFamilyMember(int index) {
    setState(() {
      familyMembers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Người Thân'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: familyMembers.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(familyMembers[index]['name']!),
                      subtitle: Text('Liên hệ: ${familyMembers[index]['contact']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            familyMembers[index]['status']!,
                            style: TextStyle(
                              color: familyMembers[index]['status'] == 'Đã nhận thông báo'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteFamilyMember(index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // Thêm logic khi ấn vào người thân (nếu cần)
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addFamilyMember,
              icon: const Icon(Icons.add),
              label: const Text('Thêm Người Thân'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
