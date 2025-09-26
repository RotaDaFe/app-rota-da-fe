import 'package:flutter/material.dart';
import 'package:rota_da_fe/style/colors.dart';

Widget ElevatedButtonCustom(
    {text,
    width,
    required Function ontap,
    textSub = "Lorem Ipsun",
    IconData icon = Icons.group_add}) {
  return InkWell(
    onTap: () {
      ontap();
    },
    child: Container(
      width: width,
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ]),
              child: Center(child: Icon(icon, size: 30, color: Colors.white))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 19),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    textSub,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
