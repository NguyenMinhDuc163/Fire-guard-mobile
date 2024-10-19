import 'package:flutter/material.dart';
import 'package:fire_guard/view/home/widget/card_widget.dart';

import '../../../init.dart';

class CardListViewWidget extends StatelessWidget {
  const CardListViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0, bottom: 15.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 175,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            CardWidget(text: 'Networking', imageUrl: AssetHelper.icoCard1, subtitle: "8 min away"),
            CardWidget(text: "Project Management", imageUrl: AssetHelper.icoCard2, subtitle: "12 min away"),
            CardWidget(text: "Security", imageUrl: AssetHelper.icoCard3, subtitle: "30 min away"),
          ],
        ),
      ),
    );
  }
}
