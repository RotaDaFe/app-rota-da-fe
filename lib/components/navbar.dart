import 'package:flutter/material.dart';
import 'package:rota_da_fe/config/config.dart';
import 'package:rota_da_fe/style/textstyles.dart';

Widget Navbar({disable_icon = false, required Function onTap, height = 90.0}) {
  return Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("images/navbar/background.png"),
            fit: BoxFit.cover),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ]),
    child: Row(
      children: [
        const Spacer(flex: 20),
        disable_icon
            ? Spacer(flex: 30)
            : InkWell(
                onTap: () {
                  onTap();
                },
                child: const SizedBox(
                    height: 60,
                    child: Image(
                      image: AssetImage("images/icon_home.png"),
                      fit: BoxFit.fitHeight,
                    )),
              ),
        const Spacer(flex: 50),
        Text(ConfigData().tituloNavBar,
            style: AppTextStyles.navbarTitle),
        const Spacer(flex: 100),
      ],
    ),
  );
}
