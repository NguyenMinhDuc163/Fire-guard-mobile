import 'package:flutter/material.dart';

class IconLanguageWidget extends StatelessWidget {
  const IconLanguageWidget({super.key, required this.name, required this.path});
  final String name;
  final String path;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey, // Màu viền
            width: 2, // Độ dày của viền
          ),
        ),
        // width: 15,
        // height: 15,
        child: (name == "EN")
            ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              path,
              fit: BoxFit.cover,
              width: 20,
              height: 20,
            ),
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              path,
              fit: BoxFit.cover,
              width: 20,
              height: 20,
            ),
          ],
        ));
  }
}
