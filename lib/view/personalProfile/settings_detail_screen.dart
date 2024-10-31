import 'package:flutter/material.dart';

class SettingsDetailScreen extends StatelessWidget {
  final String title;
  final String hintText;
  final TextInputType inputType;

  const SettingsDetailScreen({
    super.key,
    required this.title,
    required this.hintText,
    required this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: inputType,
              decoration: InputDecoration(
                labelText: hintText,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Thêm logic để xử lý thay đổi
                final input = controller.text;
                // Ví dụ: kiểm tra hoặc lưu dữ liệu
                print('$title: $input');
                Navigator.of(context).pop();
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
