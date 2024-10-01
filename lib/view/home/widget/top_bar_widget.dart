import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fire_guard/res/core/helpers/asset_helper.dart';

class TopBarWidget extends StatelessWidget {
  const TopBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ready_to_test_your_knowledge".tr(),
          style: const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                offset: const Offset(12, 26), blurRadius: 50, spreadRadius: 0, color: Colors.grey.withOpacity(.25)),
          ]),
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            // child: Icon(
            //   FontAwesomeIcons.user,
            //   size: 20,
            //   color: Color(0xff53E88B),
            // ),
            child: SvgPicture.asset(AssetHelper.icoUser),
          ),
        )
      ],
    );
  }
}

