# Ứng dụng IoT Phát Hiện Cháy và Khí Gas

## Nhóm phát triển

Dự án được phát triển bởi **Nhóm 12** trong môn **IoT và ứng dụng**. Chúng tôi tập trung vào việc xây dựng các giải pháp IoT an toàn và hiệu quả, với mục tiêu ứng dụng công nghệ vào việc phát hiện và ngăn ngừa cháy nổ, giúp tăng cường an toàn cho cộng đồng.

## Giới thiệu

Dự án này là hệ thống phát hiện cháy và khí gas dựa trên nền tảng IoT. Hệ thống sử dụng vi điều khiển ESP8266 kết hợp với cảm biến cháy và cảm biến khí gas để giám sát môi trường và phát hiện các mối nguy hiểm tiềm ẩn. Khi phát hiện có cháy hoặc khí gas, hệ thống sẽ gửi thông báo tới ứng dụng di động được phát triển bằng Flutter, giúp người dùng có thể theo dõi và nhận cảnh báo theo thời gian thực.

## Tính năng

### 1. Giám sát thời gian thực
- Hệ thống liên tục giám sát môi trường để phát hiện cháy hoặc rò rỉ khí gas.
- Cảnh báo ngay lập tức qua ứng dụng khi phát hiện nguy hiểm.

### 2. Gọi lực lượng cứu hỏa tự động
- Khi phát hiện có cháy, ứng dụng tự động gọi đến lực lượng cứu hỏa gần nhất dựa trên vị trí GPS.
- Người dùng có thể cấu hình số điện thoại của lực lượng cứu hỏa trong ứng dụng.

### 3. Thông báo cho người thân
- Tự động gửi tin nhắn hoặc thông báo đến người thân khi phát hiện sự cố.
- Người dùng có thể lưu danh sách liên hệ khẩn cấp để nhận thông tin về tình trạng cháy.

### 4. Xác định vị trí cháy trên bản đồ
- Sử dụng GPS của điện thoại để xác định vị trí phát hiện cháy và hiển thị trên bản đồ.
- Tích hợp với Google Maps hoặc OpenStreetMap để cung cấp vị trí chính xác của vụ cháy.

### 5. Xem tin tức về cháy trên cả nước
- Ứng dụng cung cấp thông tin về các vụ cháy trên cả nước thông qua tích hợp API tin tức.
- Hiển thị thông tin về các vụ cháy gần đây và các cảnh báo khu vực nguy hiểm.

### 6. Hướng dẫn kỹ năng phòng cháy chữa cháy
- Cung cấp thư viện bài viết và video hướng dẫn về kỹ năng phòng cháy chữa cháy (PCCC).
- Hướng dẫn cách xử lý tình huống khẩn cấp khi gặp cháy và sơ tán an toàn.
- Tạo trắc nghiệm để kiểm tra kiến thức về kỹ năng PCCC của người dùng.

### 7. Cảnh báo thời tiết nguy cơ cháy cao
- Hiển thị cảnh báo thời tiết về những ngày có nguy cơ cháy cao (thời tiết khô hanh, nóng bức).
- Gửi thông báo đẩy đến người dùng khi có cảnh báo thời tiết nguy hiểm.

## Phần cứng sử dụng

- **ESP8266**: Vi điều khiển chính để kết nối và truyền dữ liệu.
- **Cảm biến cháy**: Phát hiện ngọn lửa hoặc nhiệt độ cao.
- **Cảm biến khí gas**: Phát hiện rò rỉ khí gas như LPG, CO, hoặc CH4.

## Phần mềm sử dụng

- **Flutter**: Framework phát triển ứng dụng di động đa nền tảng.
- **Arduino IDE**: Để lập trình và nạp mã cho ESP8266.
- **Firebase/REST API**: (tuỳ chọn) Lưu trữ và quản lý dữ liệu cảm biến.
- **Google Maps API**: Tích hợp bản đồ và định vị GPS.
- **News API**: Tích hợp tin tức về các vụ cháy.

## Cài đặt

1. **Phần cứng**:
   - Kết nối ESP8266 với các cảm biến cháy và khí gas.
   - Kết nối ESP8266 với mạng Wi-Fi để truyền dữ liệu.

2. **Phần mềm**:
   - Lập trình ESP8266 với Arduino IDE để nhận dữ liệu từ cảm biến.
   - Cài đặt ứng dụng Flutter để nhận cảnh báo và hiển thị dữ liệu.
   
3. **Cấu hình**:
   - Cập nhật thông tin Wi-Fi và API (nếu có) trong mã nguồn của ESP8266.

## Hướng dẫn sử dụng

1. Bật nguồn hệ thống và đảm bảo kết nối mạng.
2. Mở ứng dụng Flutter trên điện thoại để theo dõi trạng thái của các cảm biến.
3. Khi có phát hiện cháy hoặc rò rỉ khí, bạn sẽ nhận được thông báo ngay lập tức trên ứng dụng.

## Tải ứng dụng

Bạn có thể tải ứng dụng tại link sau: [Fire Guard Mobile](https://github.com/NguyenMinhDuc163?tab=packages&repo_name=Fire-guard-mobile)

## Đóng góp

Nếu bạn muốn đóng góp vào dự án, hãy tạo một pull request hoặc mở issue để thảo luận thêm.

## Giấy phép

Dự án này được phát hành theo giấy phép MIT. Xem [LICENSE](./LICENSE) để biết thêm chi tiết.
