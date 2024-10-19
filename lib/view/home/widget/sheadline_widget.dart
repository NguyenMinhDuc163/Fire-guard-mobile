import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../init.dart';
class SHeadlineWidget extends StatefulWidget {
  const SHeadlineWidget({super.key, required this.topPlayers, required this.score, required this.rate});
  final List<String> topPlayers;
  final int score ;
  final double rate ;
  @override
  State<SHeadlineWidget> createState() => _SHeadlineWidgetState();
}

class _SHeadlineWidgetState extends State<SHeadlineWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "top_players".tr(),
                  style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                ),
                Text(
                  "beat_the_best".tr(),
                  style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            Text(
              "see_all".tr(),
              style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: widget.topPlayers.isNotEmpty,
          replacement: SizedBox(width: MediaQuery.of(context).size.width, height: 50, child: Text('topPlayer'.tr(), style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14))),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ListView.builder(
              itemCount: widget.topPlayers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: kDefaultPadding),
                          SvgPicture.asset(
                            AssetHelper.icoUser,
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(width: kDefaultPadding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.topPlayers[index],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 4, // Đặt chiều cao của thanh tiến trình
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300, // Màu nền của thanh tiến trình
                                    borderRadius: BorderRadius.circular(5), // Bo tròn các góc
                                  ),
                                  child:  LinearProgressIndicator(
                                    value: widget.rate, // Giá trị từ 0.0 đến 1.0
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent), // Màu của phần tiến trình
                                    backgroundColor: Colors.transparent, // Màu nền phía sau tiến trình
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: kDefaultPadding),
                           Text(
                            widget.score.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
