import 'package:fire_guard/res/core/constants/dimension_constants.dart';
import 'package:fire_guard/test.dart';
import 'package:flutter/material.dart';

import 'widget/new_item_widget.dart';

class FireNewsScreen extends StatefulWidget {
  const FireNewsScreen({super.key});

  @override
  State<FireNewsScreen> createState() => _FireNewsScreenState();
}

class _FireNewsScreenState extends State<FireNewsScreen> {
  List<bool> isSelected = [true, false];
  bool isFireNews = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height_56),
              child: Center(
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(30),
                  borderWidth: 2,
                  fillColor: Colors.orange,
                  selectedColor: Colors.white,
                  color: Colors.orange,
                  constraints: BoxConstraints(
                    minHeight: 50.0,
                    minWidth: 120.0,
                  ),
                  children: <Widget>[
                    Text('Tin tức cháy nổ'),
                    Text('Người tốt việc tốt'),
                  ],
                  isSelected: isSelected,
                  onPressed: (int index) {
                    setState(() {
                      isFireNews = !isFireNews;
                      for (int i = 0; i < isSelected.length; i++) {
                        isSelected[i] = i == index;
                      }
                    });
                  },
                ),
              ),
            ),
            Visibility(
              visible: isFireNews,
              child: Expanded(
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: [
                    NewsItemWidget(
                      imageUrl: 'https://baocantho.com.vn/image/fckeditor/upload/2024/20241007/images/Anh---Chay-o-cho-Da-Bac.webp',
                      title: 'Cháy siêu thị Điện máy Xanh giữa đêm khuya, thiệt hại ước tính hàng chục tỷ đồng',
                      time: '11:44 07/10/2024',
                      description:
                      'Quản lý cửa hàng cho biết, giá trị hàng hóa bị cháy ước tính lên đến khoảng 18 tỷ đồng...',
                    ),
                    NewsItemWidget(
                      imageUrl: 'https://baocantho.com.vn/image/fckeditor/upload/2024/20241007/images/Anh---Chay-o-cho-Da-Bac.webp',
                      title: 'Cháy dữ dội tại xưởng mây, tre đan ở Chương Mỹ, Hà Nội',
                      time: '17:06 24/09/2024',
                      description:
                      'Khu xưởng rộng hàng trăm mét vuông tại huyện Chương Mỹ, Hà Nội cháy dữ dội...',
                    ),
                    NewsItemWidget(
                      imageUrl: 'https://baocantho.com.vn/image/fckeditor/upload/2024/20241007/images/Anh---Chay-o-cho-Da-Bac.webp',
                      title: 'Gia Lai: cháy chùa Vạn Phật ở thành phố Pleiku',
                      time: '16:48 24/09/2024',
                      description:
                      'Chùa Vạn Phật tại đường Phạm Văn Đồng, thành phố Pleiku đã bị thiêu rụi...',
                    ),
                  ],
                )
              ),
              replacement: Expanded(
                child: ListView(
                  padding: EdgeInsets.all(8.0),
                  children: [
                    NewsItemWidget(
                      imageUrl: 'https://adminvov1.vov.gov.vn/UploadImages/vov1/2018/thang_6/mi%20tom.jpg?w=100%', // Thay URL bằng hình ảnh thật
                      title: 'Bác sĩ trẻ bán siêu xe ủng hộ 3 tỷ đồng giúp đỡ đồng bào vùng lũ lụt',
                      time: '11:55 17/09/2024',
                      description:
                      'Với nhiều người, có lẽ cuộc sống của họ sẽ không bao giờ trở lại như trước. Nhưng với tôi...',
                    ),
                    NewsItemWidget(
                      imageUrl: 'https://adminvov1.vov.gov.vn/UploadImages/vov1/2018/thang_6/mi%20tom.jpg?w=100%', // Thay URL bằng hình ảnh thật
                      title: 'Giáo sư 76 tuổi ủng hộ 1 tỷ cho vùng bão lũ: "Việc thiện làm mãi vẫn thấy ít"',
                      time: '11:56 13/09/2024',
                      description:
                      'Không chỉ 1 tỷ đồng ủng hộ đồng bào miền Bắc trong trận bão lũ lịch sử này, GS.TS Lê N...',
                    ),
                    NewsItemWidget(
                      imageUrl: 'https://adminvov1.vov.gov.vn/UploadImages/vov1/2018/thang_6/mi%20tom.jpg?w=100%', // Thay URL bằng hình ảnh thật
                      title: 'Những người lính "xung trận" sau bão Yagi',
                      time: '11:10 12/09/2024',
                      description:
                      'Trung tướng Doãn Thái Đức, Cục trưởng Cục cứu hộ-cứu nạn, Bộ Tổng Tham mưu Quân đội nhân dân...',
                    ),
                    NewsItemWidget(
                      imageUrl: 'https://adminvov1.vov.gov.vn/UploadImages/vov1/2018/thang_6/mi%20tom.jpg?w=100%', // Thay URL bằng hình ảnh thật
                      title: 'Cháy siêu thị Điện máy Xanh giữa đêm khuya, thiệt hại ước tính hàng chục tỷ đồng',
                      time: '11:44 07/10/2024',
                      description:
                      'Quản lý cửa hàng cho biết, giá trị hàng hóa bị cháy ước tính lên đến khoảng 18 tỷ đồng...',
                    ),
                    NewsItemWidget(
                      imageUrl: 'https://example.com/image5.jpg', // Thay URL bằng hình ảnh thật
                      title: 'Cháy dữ dội tại xưởng mây, tre đan ở Chương Mỹ, Hà Nội',
                      time: '17:06 24/09/2024',
                      description:
                      'Khu xưởng rộng hàng trăm mét vuông tại huyện Chương Mỹ, Hà Nội cháy dữ dội...',
                    ),
                  ],
                )
              ),
            )
          ],
        )
      ],
    );
  }
}
