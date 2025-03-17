import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HeadLineWidget extends StatelessWidget {
  const HeadLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "your_quizzes".tr(),
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
            ),
            Text(
              "start_a_quick_quiz".tr(),
              style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Text(
          "see_all".tr(),
          style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}

