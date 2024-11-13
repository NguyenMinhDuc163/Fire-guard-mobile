import 'package:fire_guard/viewModel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});
  static const String routeName = '/family_management';

  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  List<Map<String, String>> familyMembers = [];
  bool isLoading = false; // Thêm biến isLoading để kiểm soát trạng thái loading

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true; // Bắt đầu loading
    });

    try {
      final fetchedUsers = await Provider.of<HomeViewModel>(context, listen: false).sendUserList();
      setState(() {
        familyMembers = fetchedUsers.map<Map<String, String>>((user) => {
          'name': user.username,
          'contact': user.email,
          'status': 'Đang hoạt động',
        }).toList();
      });
    } catch (e) {
      print('Lỗi khi tải dữ liệu từ API: $e');
    } finally {
      setState(() {
        isLoading = false; // Kết thúc loading
      });
    }
  }

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
                      'status': 'Đang hoạt động',
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
      body: isLoading // Kiểm tra trạng thái loading
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading nếu isLoading = true
          : Padding(
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
                              color: familyMembers[index]['status'] == 'Đang hoạt động'
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
                        // Logic khi ấn vào người thân (nếu cần)
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
