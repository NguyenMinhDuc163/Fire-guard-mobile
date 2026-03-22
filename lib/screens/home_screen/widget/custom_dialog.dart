import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
   CustomDialog({super.key, this.cancelButtonText, this.confirmButtonText, this.title, this.onConfirm});
  String? title;
  String? cancelButtonText = 'Huỷ';
  String? confirmButtonText = 'Xác nhận';
  Function()? onConfirm;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thông báo'),
                content: const Text(
                  'Vui lòng đợi 5 phút trước khi gửi thông báo cứu hỏa tiếp theo, '
                      'hoặc có thể gọi điện trực tiếp.',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: onConfirm,
                        child: const Text('Gọi ngay'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Đóng popup
                        },
                        child: const Text('Huỷ'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Hiển thị thông báo'),
      ),
    );
  }
}
