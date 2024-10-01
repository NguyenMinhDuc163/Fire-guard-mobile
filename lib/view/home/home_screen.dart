import 'package:flutter/material.dart';
import 'package:fire_guard/res/core/constants/color_constants.dart';
import 'package:fire_guard/view/home/widget/headline_widget.dart';
import 'package:fire_guard/view/home/widget/card_list_view_widget.dart';
import 'package:fire_guard/view/home/widget/promo_card_widget.dart';
import 'package:fire_guard/view/home/widget/search_input_widget.dart';
import 'package:fire_guard/view/home/widget/sheadline_widget.dart';

import 'widget/top_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: ColorPalette.slateGray,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                TopBarWidget(),
                SearchInputWidget(),
                PromoCardWidget(),
                HeadLineWidget(),
                CardListViewWidget(),
                SHeadlineWidget(topPlayers: ['Nguyen Minh Duc ', 'Nguyen Minh Duc','Nguyen Minh Duc', 'Nguyen Minh Duc'], score: 100, rate: 4.5),
              ],
            ),
          ),
        ));
  }
}


