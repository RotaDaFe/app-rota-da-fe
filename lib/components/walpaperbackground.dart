import 'package:flutter/material.dart';

Widget WalpaperBackground(
    {required Widget child, String image = "images/banner1.png"}) {
  return SizedBox(
    height: 300,
    child: Stack(children: [
      Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(image), fit: BoxFit.cover))),
      child
    ]),
  );
}
