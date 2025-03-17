import 'package:easy_localization/easy_localization.dart';
import 'package:fire_guard/utils/core/helpers/local_storage_helper.dart';
import 'package:fire_guard/screens/family_manager_screen/providers/family_manager_view_model.dart';
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
      context
          .read<FamilyManagerViewModel>()
          .fetchFamily(LocalStorageHelper.getValue('userId'));
    });
  }

  void _showAddMemberBottomSheet() {
    final TextEditingController controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'family_manager.add_member'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'family_manager.member_email'.tr(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<FamilyManagerViewModel>().addFamily(
                            ownerID: LocalStorageHelper.getValue('userId'),
                            email: value,
                          );
                      context
                          .read<FamilyManagerViewModel>()
                          .fetchFamily(LocalStorageHelper.getValue('userId'));
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  Text('common.cancel'.tr()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          String value = controller.text;
                          if (value.isNotEmpty) {
                            context.read<FamilyManagerViewModel>().addFamily(
                                  ownerID:
                                      LocalStorageHelper.getValue('userId'),
                                  email: value,
                                );
                            context.read<FamilyManagerViewModel>().fetchFamily(
                                LocalStorageHelper.getValue('userId'));
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  Text('family_manager.confirm'.tr()),
                      ),
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
        title:  Text('family_manager.manage_family'.tr()),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Consumer<FamilyManagerViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            );
          }

          if (viewModel.familyMembers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'family_manager.no_members'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                viewModel.fetchFamily(LocalStorageHelper.getValue('userId')),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.familyMembers.length,
              itemBuilder: (context, index) {
                final member = viewModel.familyMembers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      child: Text(
                        member.username?.substring(0, 1).toUpperCase() ?? '?',
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      member.username ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (member.phoneNumber != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.phone,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                member.phoneNumber!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                             Text(
                              'family_manager.activity'.tr(),
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                      onPressed: () {
                        context.read<FamilyManagerViewModel>().deleteFamily(
                              userId: LocalStorageHelper.getValue('userId'),
                              familyMemberId: member.familyMemberId ?? 1,
                            );
                        viewModel
                            .fetchFamily(LocalStorageHelper.getValue('userId'));
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
