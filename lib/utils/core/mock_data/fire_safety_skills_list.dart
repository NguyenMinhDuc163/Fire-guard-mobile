import 'package:fire_guard/view/fireSafetySkills/skill_item.dart';
import 'package:flutter/material.dart';

class FireSafetySkillsList extends StatelessWidget {
  const FireSafetySkillsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        SkillItem(
          number: '1',
          title: 'Cách xử lý khi phát hiện đám cháy',
          content: 'Khi phát hiện ra cháy, nhanh chóng thông báo, hô hoán cho mọi người biết về vụ cháy. Ngắt điện nhà bị cháy (nếu có thể). Huy động thêm mọi người xung quanh di chuyển người trong nhà ra ngoài nơi an toàn. Gọi điện thoại cho lực lượng PCCC qua số 114, cung cấp địa chỉ khu vực xảy ra cháy, thông tin người bị nạn, đặc điểm khu vực bị cháy, và số điện thoại liên hệ. Cùng với mọi người sử dụng các vật dụng để chữa cháy như bình chữa cháy, xô chậu múc nước, hoặc chăn thấm nước. Cử người đón lực lượng PCCC.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2020/12/114.jpg',
        ),
        SkillItem(
          number: '2',
          title: 'Cách xử lý khi bị bắt lửa vào quần áo',
          content: 'Bình tĩnh, không hoảng sợ, dừng chạy ngay lập tức. Nằm nhanh xuống sàn nhà hoặc áp mình vào tường; không lấy tay dập lửa và không được nhảy vào hồ bơi hay bể nước trừ khi chắc chắn an toàn. Một tay che miệng, một tay che mắt, mũi, và tiếp tục cuộn tròn cho tới khi lửa tắt hoàn toàn.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2020/12/bo.jpg',
        ),
        SkillItem(
          number: '3',
          title: 'Cách xử lý khi thấy người khác bị cháy',
          content: 'Trấn an người đó không hoảng sợ, dừng chạy ngay lập tức. Dùng chăn thấm nước hoặc các bình bột, nước để dập tắt lửa. Đưa người bị cháy đến cơ sở y tế gần nhất để được chăm sóc và theo dõi tình trạng sức khỏe.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2019/03/tui-y-te-1.png',
        ),
        SkillItem(
          number: '4',
          title: 'Cách sơ cứu người bị ngừng thở',
          content: 'Nếu nạn nhân ngừng thở nhưng mạch còn đập, tiến hành hô hấp nhân tạo ngay lập tức. Nếu cả mạch và nhịp thở đều ngừng, thực hiện hô hấp nhân tạo kết hợp ép tim ngoài lồng ngực theo chu kỳ: 2 lần thổi ngạt và 30 lần ép tim. Tiếp tục cho đến khi nạn nhân tự thở được hoặc có người hỗ trợ.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2020/12/bo.jpg',
        ),
        SkillItem(
          number: '5',
          title: 'Cách sơ cứu người bị bỏng',
          content: 'Sử dụng nước sạch (nhiệt độ từ 16–20°C) để ngâm và rửa vết bỏng. Có thể dùng nước máy, nước mưa, hoặc nước giếng. Ngâm hoặc rửa phần bị bỏng dưới vòi nước, dội nước liên tục lên vùng bỏng hoặc dùng khăn ướt. Cắt bỏ quần áo cháy, rửa sạch dị vật, và đưa nạn nhân đến cơ sở y tế gần nhất.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2020/12/den-exit-Kentom-.jpg',
        ),
        SkillItem(
          number: '6',
          title: 'Cách sơ cứu người hít phải khói',
          content: 'Đưa nạn nhân ra khỏi nơi nguy hiểm đến nơi thoáng khí. Nếu nạn nhân bất tỉnh, kiểm tra nhịp thở và mạch, thực hiện hô hấp nhân tạo nếu cần. Đặt nạn nhân ở tư thế hồi sức, cho thở oxy nếu có sẵn, và chữa các vết thương khác trước khi đưa đến cơ sở y tế.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2019/06/daycuunguoi-met.jpg',
        ),
        SkillItem(
          number: '7',
          title: 'Kỹ năng thoát hiểm trong nhà cao tầng',
          content: 'Khi sống trong tòa nhà, cần chú ý các đường thoát hiểm. Khi có cháy, giữ bình tĩnh và tìm lối thoát an toàn theo chỉ dẫn, không sử dụng thang máy. Che miệng bằng khăn ướt, cúi thấp người khi di chuyển qua khói để tránh ngạt.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2020/11/79927629_2803065309757224_7185605484504678400_n-1024x584.png',
        ),
        SkillItem(
          number: '8',
          title: 'Cách xử lý khi có mùi gas trong nhà',
          content: 'Khi phát hiện mùi gas, không bật công tắc điện hoặc dùng điện thoại di động. Mở cửa nhẹ nhàng để khí gas thoát ra ngoài, khóa van gas và gọi nhà cung cấp để xử lý. Nếu lửa cháy trên bình gas, dùng chăn ướt hoặc bình chữa cháy để dập lửa.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2020/07/abc-4kg.png',
        ),
        SkillItem(
          number: '9',
          title: 'Cách lắp đặt và sử dụng thiết bị điện an toàn',
          content: 'Kiểm tra và lắp đặt áptômát cho đường điện chính và từng thiết bị công suất lớn. Tránh dùng dây điện nhỏ cho thiết bị công suất lớn, và ngắt các thiết bị điện không cần thiết trước khi ra khỏi nhà hoặc đi ngủ.',
          imageUrl: 'https://pcccanphuc.vn/wp-content/uploads/2020/07/abc-4kg.png',
        ),
      ],
    )
    ;
  }
}

class EscapeSkillsList extends StatelessWidget {
  const EscapeSkillsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const [
        SkillItem(
          number: '1',
          title: 'Giữ bình tĩnh',
          content: 'Việc giữ trạng thái bình tĩnh sẽ giúp bạn xử lý tình huống tốt hơn. Nếu là đám cháy nhỏ, hãy dùng bình chữa cháy để phun dập lửa ngay lập tức. Trong trường hợp là đám cháy lớn, bạn cần phải giữ bình tĩnh để tìm ra phương án giải quyết tối ưu. Nếu đám cháy có xu hướng lan rộng, hãy thông báo cho mọi người bằng cách hô hoán, đánh kẻng hoặc phát thanh trên loa để cùng nhau phối hợp dập lửa hoặc sơ tán đến nơi an toàn.',
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIkfzySxVRP5_WV9PSNhtGP5EYWpm2AIFXXw&s',
        ),
        SkillItem(
          number: '2',
          title: 'Chống ngạt',
          content: 'Đa số các trường hợp tử vong khi có cháy là do bị ngạt khí độc. Nếu có thể, hãy lấy khăn hoặc vải thấm nước để che kín miệng và mũi, giúp lọc không khí và tránh hít phải khói độc. Tuyệt đối không lại gần những khu vực kín hoặc có khả năng phát nổ. Khi di chuyển, hãy cúi thấp người, bò trên sàn và dùng khăn ướt để che miệng mũi. Kiểm tra độ nóng của cửa trước khi mở. Nếu cửa quá nóng, đừng mở mà hãy tìm lối thoát khác.',
          imageUrl: 'https://baovengayvadem.com/wp-content/uploads/2023/05/Chong-hit-phai-khoi-nhieu-bang-khan-tham-nuoc.jpg',
        ),
        SkillItem(
          number: '3',
          title: 'Không dùng thang máy',
          content: 'Khi có hỏa hoạn, không sử dụng thang máy vì hệ thống điện có thể bị ngắt, dẫn đến việc bạn có thể bị kẹt bên trong. Thang máy cũng dễ bị lấp đầy khói, gây nguy hiểm đến tính mạng. Thay vào đó, hãy sử dụng cầu thang bộ và men theo bờ tường để giữ phương hướng trong điều kiện có khói và lửa.',
          imageUrl: 'https://baovengayvadem.com/wp-content/uploads/2023/05/Khong-dung-thang-may.jpg',
        ),
        SkillItem(
          number: '4',
          title: 'Kiểm tra cửa trước khi mở',
          content: 'Trước khi mở cửa, hãy kiểm tra độ nóng của cửa bằng mu bàn tay. Nếu cảm thấy cửa nóng, điều đó cho thấy ngọn lửa đang bùng phát mạnh bên ngoài và bạn không nên mở cửa. Nếu cửa không nóng, hãy mở cửa một cách thận trọng bằng cách đứng nghiêng người để tránh lửa tạt vào. Nếu khói đã bao trùm hành lang, hãy dùng khăn ẩm bịt kín các khe cửa và chờ đội cứu hộ đến.',
          imageUrl: 'https://tuyengiaokhanhhoa.vn/Media/Articles/050921010315/ky-nang-thoat-hiem-khi-chay-nha-cao-tang-lam-sao-de-thoat-khoi-nha-cao-tang-dang.jpg',
        ),
        SkillItem(
          number: '5',
          title: 'Báo động và cầu cứu',
          content: 'Khi khói lan ra toàn bộ căn phòng và bạn không thể thoát ra bằng lối cửa chính, hãy nhanh chóng di chuyển ra ban công hoặc cửa sổ. Từ đó, hét lớn cầu cứu hoặc dùng đèn flash điện thoại, vẫy khăn hoặc áo sáng màu để thu hút sự chú ý của lực lượng cứu hộ. Đồng thời, gọi lực lượng phòng cháy chữa cháy theo số 114 và thông báo vị trí cụ thể của bạn để họ có thể ứng cứu kịp thời.',
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXG6H1EbwPaKCQOlW65nLXq_0K9wrivp-mnQ&s',
        ),
        SkillItem(
          number: '6',
          title: 'Nghe theo chỉ dẫn của đội cứu hộ',
          content: 'Khi được lực lượng cứu hộ đưa ra khỏi khu vực nguy hiểm, hãy giữ bình tĩnh và làm theo chỉ dẫn của họ. Không tự ý sơ cứu hoặc hành động theo người khác khi chưa được cho phép. Nếu có thể, hãy hỗ trợ những người yếu thế như trẻ em, người già hoặc người khuyết tật để đảm bảo an toàn cho tất cả mọi người.',
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXG6H1EbwPaKCQOlW65nLXq_0K9wrivp-mnQ&s',
        ),
        SkillItem(
          number: '7',
          title: 'Không núp ở nơi khó tìm',
          content: 'Khi chạy thoát hiểm, không nên núp ở những nơi khó tìm như nhà vệ sinh hoặc phòng kín, vì đây là những khu vực dễ bị khói bao trùm và không có lối thoát. Hãy di chuyển đến nơi có không khí trong lành và dễ dàng tiếp cận để lực lượng cứu hộ có thể nhanh chóng tìm thấy bạn.',
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFyNg05u6c0SRy_zcrSw1T6thRPAcwNdHk9Q&s',
        ),
        SkillItem(
          number: '8',
          title: 'Kỹ năng xử lý khi bị bén lửa',
          content: 'Nếu quần áo của bạn bị bén lửa, đừng chạy vì lửa sẽ cháy mạnh hơn. Thay vào đó, nằm xuống đất, úp tay che mặt và lăn qua lăn lại cho đến khi lửa tắt. Nếu có nguồn nước gần đó, hãy nhanh chóng sử dụng nước để dập lửa. Luôn cố gắng giữ bình tĩnh và chờ sự trợ giúp từ người xung quanh hoặc đội cứu hộ.',
          imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXG6H1EbwPaKCQOlW65nLXq_0K9wrivp-mnQ&s',
        ),
        SkillItem(
          number: '9',
          title: 'Xử lý sau khi thoát ra ngoài',
          content: 'Khi thoát khỏi đám cháy, hãy di chuyển đến nơi an toàn và không quay lại khu vực cháy. Men theo bờ tường để giữ phương hướng trong khói, và tìm kiếm sự trợ giúp nếu cần. Nếu có người bị thương, hãy chờ đội cứu hộ hoặc đưa họ đến cơ sở y tế gần nhất.',
          imageUrl: 'https://baovengayvadem.com/wp-content/uploads/2023/05/Xu-ly-khi-bi-ben-lua.png',
        ),
      ],
    )
    ;
  }
}
