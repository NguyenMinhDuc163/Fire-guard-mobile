import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import thư viện url_launcher

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String type;
  final String url;
  final String content;
  final String urlImage;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.type,
    required this.url,
    required this.content,  required this.urlImage,
  });

  // Hàm mở URL
  Future<void> _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontSize: 18),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder cho video hoặc hình ảnh
            if (type == 'video')
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.black,
                child: const Center(
                  child: Text(
                    'Video Player Placeholder',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            else
            // Hình ảnh nếu không phải video
              Image.network(
                urlImage,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),

            // Tiêu đề
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),

            // Nội dung bài viết
            if (type == 'article' && content != null)
              Text(
                content!,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            if (type == 'article' && content == null)
              const Text(
                'Nội dung đang được cập nhật...',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 20),

            // Nút mở liên kết
            Visibility(
              visible: false,
              child: Center(
                child: ElevatedButton(
                  onPressed: _launchURL,
                  child: const Text('Mở liên kết đầy đủ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
