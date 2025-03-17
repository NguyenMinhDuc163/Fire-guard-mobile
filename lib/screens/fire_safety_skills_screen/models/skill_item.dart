import 'package:flutter/material.dart';
import '../views/skill_detail_screen.dart'; // Import màn hình chi tiết

class SkillItem extends StatelessWidget {
  final String number;
  final String title;
  final String content;
  final String imageUrl;

  const SkillItem({
    required this.number,
    required this.title,
    required this.content,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Điều hướng đến màn hình chi tiết khi nhấn vào
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SkillDetailScreen(
              title: title,
              content: content,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Card(
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
          title: Text(title),
        ),
      ),
    );
  }
}
