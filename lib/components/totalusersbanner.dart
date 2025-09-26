import 'package:flutter/material.dart';
import 'package:rota_da_fe/style/colors.dart';

Widget TotalUsersBanner({text = 15, width}) {
  return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 130,
        width: width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 125,
                width: width - 20,
                decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(.5),
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Container(
              height: 120,
              width: width - 10,
              decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.group,
                    size: 70,
                    color: Colors.white,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Total de cadatros",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            text,
                            style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ));
}
