import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/viewModel/family_manager_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FamilyManagementScreen extends StatefulWidget {
  const FamilyManagementScreen({super.key});
  static const String routeName = '/family_management';

  @override
  State<FamilyManagementScreen> createState() => _FamilyManagementScreenState();
}

class _FamilyManagementScreenState extends State<FamilyManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Giả sử userId = 1, trong thực tế nên lấy từ authentication
    Future.delayed(Duration.zero, () {
      context.read<FamilyManagerViewModel>().fetchFamily(LocalStorageHelper.getValue('userId'));
    });
  }

  void _showAddMemberBottomSheet() {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Thêm Thành Viên',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'ID Thành viên',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      // Giả sử userId = 1
                      context.read<FamilyManagerViewModel>().addFamily(
                        userId: LocalStorageHelper.getValue('userId'),
                        familyMemberId:  int.parse(value),
                      );
                      context.read<FamilyManagerViewModel>().fetchFamily(LocalStorageHelper.getValue('userId'));

                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Kiểm tra giá trị và gọi API khi ấn nút "Thêm"
                        String value = controller.text;
                        if (value.isNotEmpty) {
                          // Giả sử userId = 1
                          context.read<FamilyManagerViewModel>().addFamily(
                            userId: LocalStorageHelper.getValue('userId'),
                            familyMemberId:  int.parse(value),
                          );
                          context.read<FamilyManagerViewModel>().fetchFamily(LocalStorageHelper.getValue('userId'));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Thêm'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // final familyViewModel = Provider.of<FamilyManagerViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Người Thân'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<FamilyManagerViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.familyMembers.isEmpty) {
            return const Center(
              child: Text(
                'Chưa có thành viên nào trong danh sách',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.fetchFamily(LocalStorageHelper.getValue('userId')),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.familyMembers.length,
              itemBuilder: (context, index) {
                final member = viewModel.familyMembers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      member.username ?? 'Chưa có tên',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (member.phoneNumber != null)
                          Text('SĐT: ${member.phoneNumber}'),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Hoạt động',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<FamilyManagerViewModel>().deleteFamily(
                          userId: LocalStorageHelper.getValue('userId'),
                          familyMemberId: member.familyMemberId,
                        );
                        viewModel.fetchFamily(LocalStorageHelper.getValue('userId'));
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMemberBottomSheet,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
