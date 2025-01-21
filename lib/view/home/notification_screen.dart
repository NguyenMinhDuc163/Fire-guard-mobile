import 'package:fire_guard/view/widger/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewModel/home_view_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static const String routeName = '/notifications';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];
  DateTime? startDate = DateTime.now().subtract(const Duration(days: 1));
  DateTime? endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadNotifications();
    });
  }

  Future<void> _loadNotifications() async {
    if (startDate != null && endDate != null && startDate!.isAfter(endDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ngày bắt đầu phải nhỏ hơn hoặc bằng ngày kết thúc.')),
      );
      return;
    }

    try {
      final fetchedNotifications = await Provider.of<HomeViewModel>(context, listen: false)
          .fetchHistory(
          startDate: startDate ?? DateTime.now().subtract(const Duration(days: 1)),
          endDate: endDate ?? DateTime.now());

      setState(() {
        notifications = fetchedNotifications;
      });
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final model = homeViewModel.model;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông Báo Cảnh Báo'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await _loadNotifications();
            },
            child: Column(
              children: [
                // Card chứa các bộ lọc tìm kiếm
                Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, isStartDate: true),
                                child: buildDateField(
                                  label: 'Ngày bắt đầu',
                                  date: startDate,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _selectDate(context, isStartDate: false),
                                child: buildDateField(
                                  label: 'Ngày kết thúc',
                                  date: endDate,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadNotifications,
                          icon: const Icon(Icons.search),
                          label: const Text('Tìm kiếm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: notifications.isNotEmpty
                      ? ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Dismissible(
                        key: Key(notification['incidentId'].toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            notifications.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Đã xóa thông báo: ${notification['message']}')),
                          );
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.warning, color: Colors.red),
                            title: Text(
                              notification['message'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Thời gian: ${notification['timestamp']}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              // Gọi BottomSheet hiển thị chi tiết thông báo
                              _showNotificationDetails(context, notification);
                            },
                          ),
                        ),
                      );
                    },
                  )
                      : const Center(child: Text('Không có thông báo !!!.')),
                ),
              ],
            ),
          ),
          homeViewModel.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
    );
  }

  // Hàm xây dựng BottomSheet hiển thị chi tiết thông báo
  void _showNotificationDetails(BuildContext context, Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['title'] ?? 'Chi tiết thông báo',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Nội dung:',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(notification['body'] ?? 'Không có thông tin.'),
              const SizedBox(height: 16),
              Text(
                'Thời gian: ${notification['timestamp']}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Hàm xây dựng trường ngày với nhãn và ngày đã chọn
  Widget buildDateField({required String label, DateTime? date}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            date != null ? DateFormat('dd/MM/yyyy').format(date) : label,
            style: TextStyle(
              fontSize: 16,
              color: date != null ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
