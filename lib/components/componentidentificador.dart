import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget componentIdentificador({width, margem, email, bloco}) {
  return Container(
    height: 150,
    width: width - margem,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),  
            offset: const Offset(0, 4),  
            blurRadius: 4,  
            spreadRadius: 0,  
          )
        ]),
    child: Row(
      children: [
        Expanded(
            flex: 100,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: AutoSizeText(email,
                          maxLines: 1, style: const TextStyle(fontSize: 20))),
                  Align(
                      alignment: Alignment.topLeft,
                      child: AutoSizeText('bloco: $bloco',
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.black.withOpacity(.5),
                          ))),
                ],
              ),
            )),
        Center(
            child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage("images/iconAccountSantinhaa.png"),
                        fit: BoxFit.fitHeight),
                    borderRadius: BorderRadius.circular(20)))),
        const SizedBox(width: 10)
      ],
    ),
  );
}
