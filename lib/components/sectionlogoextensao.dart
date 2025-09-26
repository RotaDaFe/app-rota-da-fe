import 'package:flutter/material.dart';

Widget SectionLogoExtensao() {
  return SizedBox(
      child: Column(children: [
    Text("Projeto de extensão",
        style: TextStyle(fontSize: 18, color: Colors.green[800])),
    const SizedBox(height: 5),
    const SizedBox(
        height: 70,
        child: Image(
            image: AssetImage(
          "images/logoUnama.png",
        ))),
    const SizedBox(height: 5),
    Text("Faculdade Unama",
        style: TextStyle(fontSize: 18, color: Colors.green[800])),
  ]));
}
