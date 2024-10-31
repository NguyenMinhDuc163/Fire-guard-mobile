import 'package:fire_guard/view/fireNews/NewsItem.dart';
import 'package:fire_guard/view/fireNews/news_detail_screen.dart';
import 'package:fire_guard/view/fireNews/widget/new_item_widget.dart';
import 'package:flutter/material.dart';

class FireNewsList extends StatelessWidget {
  final List<NewsItem> fireNews = [
    NewsItem(
      title: 'Bãi giữ xe vi phạm bị cháy',
      type: 'article',
      imageUrl: 'https://i1-vnexpress.vnecdn.net/2024/10/27/462540874-577715744606632-5241-4582-1117-1729990003.jpg?w=1020&h=0&q=100&dpr=1&fit=crop&s=bVvu5bOPj0ZXixH2PQtyJA',
      content: 'Trong đêm mưa, hàng chục xe máy vi phạm bị thiêu rụi sau vụ cháy bãi giữ xe của Phòng Cảnh sát giao thông tỉnh Thừa Thiên Huế.Khoảng 21h30 ngày 26/10, người dân sống xung quanh trụ sở phòng Cảnh sát giao thông tỉnh Thừa Thiên Huế ở phường An Đông, TP Huế, phát hiện lửa ở khu vực bãi tạm giữ xe vi phạm giao thông. Chỉ trong vài phút, ngọn lửa lan rộng, hàng chục xe máy vi phạm bốc cháy dữ dội, khói cao hơn chục mét. Cảnh sát Phòng cháy chữa cháy và Cứu nạn cứu hộ đã huy động xe chữa cháy cùng chiến sĩ tham gia khống chế ngọn lửa. Hơn 22h30, hỏa hoạn cơ bản được khống chế song hàng chục xe máy bị cháy trơ khung, nhiều xe bị hư hỏng.Nguyên nhân vụ cháy đang được điều tra.',
      time: '11:44 07/10/2024',
      url: 'https://vnexpress.net', // URL đầy đủ
    ),
    NewsItem(
      title: 'Cháy xưởng gỗ 1.000 m2 trong khu dân cư ở TP HCM',
      type: 'article',
      imageUrl: 'https://i1-vnexpress.vnecdn.net/2024/10/25/03e6218444f9fca7a5e8-5680-1729843490.jpg?w=1020&h=0&q=100&dpr=1&fit=crop&s=JKIMn4kmK1Bu9bnoFvZ0gw',
      content: '''Tia lửa phát ra trong quá trình hàn xì đã làm bùng cháy xưởng gỗ rộng gần 1.000 m2 trong khu dân cư ở TP Thủ Đức, cột khói bốc cao hàng chục mét, chiều 25/10.

Gần 13h, người dân sống trong khu dân cư trong hẻm đường Tô Ngọc Vân, phường Linh Đông phát hiện khói lửa phát ra từ xưởng gỗ rộng gần 1.000 m2 nên hô hoán dập lửa.
Nhiều người bên trong xưởng vội chạy ra ngoài trước khi đám cháy bùng lên dữ dội. Khói lửa tỏa lên nghi ngút, lan ra khu dân cư khiến nhiều người hoảng loạn. Một số hộ sống ở dãy trọ bên cạnh phải di dời để tránh ngạt khói đen.

Nhiều xe chữa cháy cùng hơn 20 chiến sĩ đến hiện trường. Lính cứu hỏa kéo vòi rồng dập lửa, leo lên mái tôn để xịt nước ngăn cháy lan. Đến 13h30, đám cháy được khống chế.
Đại diện UBND phường Linh Đông cho hay hai người trong lúc hàn xì để tháo dở đồ đạc trong xưởng gỗ đã làm rơi tia lửa gây cháy. Xưởng này đã ngừng hoạt động, hầu hết máy móc, tài sản đi nơi khác nên không có thiệt hại.''',
      time: '17:06 24/09/2024',
      url: 'https://baocantho.com.vn/full-article-link-2', // URL đầy đủ
    ),
    NewsItem(
      title: 'Cứu 4 người trong vụ cháy ở Bắc Ninh',
      type: 'article',
      imageUrl: 'https://i1-vnexpress.vnecdn.net/2024/10/19/5944785081382-mp4-00-01-11-26-9702-7681-1729315346.jpg?w=1020&h=0&q=100&dpr=1&fit=crop&s=zjkCt2CBe_lLk-07sO9qeA',
      content: '''Ngọn lửa dữ dội bao trùm ngôi nhà ở kết hợp kinh doanh tại huyện Yên Phong khiến 4 người mắc kẹt, được lực lượng chức năng cứu sống.

Khoảng 3h ngày 19/10, lửa bùng lên tại ngôi nhà ở kết hợp kinh doanh nguyên liệu pha chế đồ uống rộng khoảng 80 m2 của gia đình ông Lê Quang Lợi ở khu đô thị mới thị trấn Chờ, huyện Yên Phong.

Đám cháy xuất phát từ tầng một, nơi chứa nhiều vật liệu dễ cháy như túi nylon, bìa carton và nguyên liệu pha chế. Khói đen đặc quánh nhanh chóng bao trùm ngôi nhà, khiến bốn người mắc kẹt, kêu cứu từ tầng hai.
Công an huyện Yên Phong có trụ sở gần đó đã nhanh chóng tới dùng phương tiện chữa cháy tại chỗ khống chế ngọn lửa và hướng dẫn hai người mắc kẹt thoát ra ngoài qua ban công tầng hai. Các nạn nhân sau đó được đưa đi cấp cứu tại Trung tâm Y tế huyện.

Hai xe chữa cháy chuyên dụng cùng lực lượng Cảnh sát Phòng cháy chữa cháy sau đó có mặt với đồ bảo hộ và đeo bình dưỡng khí, leo thang tiếp cận tầng hai, đưa hai nạn nhân còn lại ra ngoài.

Sau khoảng một giờ, đám cháy được dập tắt hoàn toàn. Nguyên nhân cháy đang được làm rõ.''',
      time: '16:48 24/09/2024',
      url: 'https://baocantho.com.vn/full-article-link-3', // URL đầy đủ
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: fireNews.map((newsItem) {
        return NewsItemWidget(
          imageUrl: newsItem.imageUrl,
          title: newsItem.title,
          time: newsItem.time,
          description: newsItem.content,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsDetailScreen(
                  title: newsItem.title,
                  type: newsItem.type,
                  url: newsItem.url, // Truyền URL đầy đủ
                  content: newsItem.content,
                  urlImage: newsItem.imageUrl,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
