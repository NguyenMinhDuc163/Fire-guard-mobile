import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fire_guard/res/core/constants/dimension_constants.dart';
import 'package:fire_guard/res/core/helpers/asset_helper.dart';

class PromoCardWidget extends StatelessWidget {
  const PromoCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(colors: [Color(0xff53E88B), Color(0xff15BE77)])),
        child: Stack(
          children: [
            Opacity(
              opacity: .5,
              child: Image.asset(AssetHelper.backgroundCard, fit: BoxFit.cover),
            ),
            Image.asset(AssetHelper.quizz, fit: BoxFit.cover),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "get_started_now".tr(),
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO Thực hiện hành động khi nhấn nút
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Màu của text
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Bo góc của button
                    ),
                  ),
                  child: Text('start_now'.tr()),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

