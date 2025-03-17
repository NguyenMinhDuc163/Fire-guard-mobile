import 'package:fire_guard/utils/core/constants/error_constants.dart';
import 'package:fire_guard/screens/widger/LoadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fire_guard/utils/core/constants/color_constants.dart';
import '../providers/home_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

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
        SnackBar(
          content: Text('notification.date_error'.tr()),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final fetchedNotifications =
          await Provider.of<HomeViewModel>(context, listen: false).fetchHistory(
              startDate:
                  startDate ?? DateTime.now().subtract(const Duration(days: 1)),
              endDate: endDate ?? DateTime.now());

      setState(() {
        notifications = fetchedNotifications;
      });
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
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
        title: Text(
          'notification.title'.tr(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorPalette.colorFFBB35,
        elevation: 0,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await _loadNotifications();
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  _selectDate(context, isStartDate: true),
                              child: buildDateField(
                                label: 'notification.start_date'.tr(),
                                date: startDate,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  _selectDate(context, isStartDate: false),
                              child: buildDateField(
                                label: 'notification.end_date'.tr(),
                                date: endDate,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadNotifications,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPalette.colorFFBB35,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          'notification.search'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: notifications.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            final errorMessage =
                                notification['message'] as String;
                            final errorColor =
                                ErrorConstants.getErrorColor(errorMessage);
                            final errorIcon =
                                ErrorConstants.getErrorIcon(errorMessage);
                            final formattedMessage =
                                ErrorConstants.getErrorMessage(errorMessage);

                            return Dismissible(
                              key: Key(notification['incidentId'].toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  notifications.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'notification.delete_success'
                                          .tr(args: [formattedMessage]),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: errorColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      errorIcon,
                                      color: errorColor,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    formattedMessage,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: errorColor,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '${'notification.time'.tr()}: ${notification['timestamp']}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    _showNotificationDetails(
                                        context, notification);
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'notification.no_notifications'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          homeViewModel.isLoading ? const LoadingWidget() : const SizedBox(),
        ],
      ),
    );
  }

  void _showNotificationDetails(
      BuildContext context, Map<String, dynamic> notification) {
    final errorMessage = notification['message'] as String;
    final errorColor = ErrorConstants.getErrorColor(errorMessage);
    final formattedMessage = ErrorConstants.getErrorMessage(errorMessage);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    ErrorConstants.getErrorIcon(errorMessage),
                    color: errorColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      formattedMessage,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: errorColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${'notification.time'.tr()}: ${notification['timestamp']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: errorColor,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'notification.close'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildDateField({required String label, DateTime? date}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: ColorPalette.colorFFBB35, size: 22),
          const SizedBox(width: 12),
          Text(
            date != null ? DateFormat('dd/MM/yyyy').format(date) : label,
            style: TextStyle(
              fontSize: 15,
              color: date != null ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
