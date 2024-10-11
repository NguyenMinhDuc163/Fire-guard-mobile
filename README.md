# Ứng dụng IoT Phát Hiện Cháy và Khí Gas

## Giới thiệu

Dự án này là hệ thống phát hiện cháy và khí gas dựa trên nền tảng IoT. Hệ thống sử dụng vi điều khiển ESP8266 kết hợp với cảm biến cháy và cảm biến khí gas để giám sát môi trường và phát hiện các mối nguy hiểm tiềm ẩn. Khi phát hiện có cháy hoặc khí gas, hệ thống sẽ gửi thông báo tới ứng dụng di động được phát triển bằng Flutter, giúp người dùng có thể theo dõi và nhận cảnh báo theo thời gian thực.

## Tính năng

- **Giám sát thời gian thực**: Hệ thống liên tục giám sát môi trường để phát hiện cháy hoặc rò rỉ khí gas.
- **Cảnh báo qua ứng dụng di động**: Khi phát hiện nguy hiểm, hệ thống sẽ gửi cảnh báo tới ứng dụng di động.
- **Kết nối IoT**: Sử dụng ESP8266 để giao tiếp và truyền dữ liệu từ cảm biến lên ứng dụng.
- **Ứng dụng di động đa nền tảng**: Ứng dụng di động được xây dựng bằng Flutter, có thể chạy trên cả Android và iOS.

## Phần cứng sử dụng

- **ESP8266**: Vi điều khiển chính để kết nối và truyền dữ liệu.
- **Cảm biến cháy**: Phát hiện ngọn lửa hoặc nhiệt độ cao.
- **Cảm biến khí gas**: Phát hiện rò rỉ khí gas như LPG, CO, hoặc CH4.

## Phần mềm sử dụng

- **Flutter**: Framework phát triển ứng dụng di động đa nền tảng.
- **Arduino IDE**: Để lập trình và nạp mã cho ESP8266.
- **Firebase/REST API**: (tuỳ chọn) Lưu trữ và quản lý dữ liệu cảm biến.

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

## Nhóm phát triển

Dự án được phát triển bởi **Nhóm 12** trong môn **IoT và ứng dụng**.

## Đóng góp

Nếu bạn muốn đóng góp vào dự án, hãy tạo một pull request hoặc mở issue để thảo luận thêm.

## Giấy phép

Dự án này được phát hành theo giấy phép MIT. Xem [LICENSE](./LICENSE) để biết thêm chi tiết.
