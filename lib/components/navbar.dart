import 'package:flutter/material.dart';
import 'package:rota_da_fe/config/config.dart';
import 'package:rota_da_fe/style/colors.dart';

Widget Navbar({disable_icon = false, required Function onTap, height = 90.0}) {
  return Container(
    height: height,
    width: double.infinity,
    decoration: BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.1),  
        offset: const Offset(0, 4),  
        blurRadius: 4,  
        spreadRadius: 0,  
      ),
    ], color: AppColors.primary ),
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
            style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        const Spacer(flex: 100),
      ],
    ),
  );
}
