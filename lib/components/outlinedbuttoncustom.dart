import 'package:flutter/material.dart';
import 'package:rota_da_fe/style/colors.dart';

Widget OutlinedButtonCustom(
    {text = '',
    required Function ontap,
    Color color = AppColors.secondary}) {
  return InkWell(
    onTap: () {
      ontap();
    },
    child: Container(
      width: 200,
      height: 60,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1), 
              offset: const Offset(0, 4),  
              blurRadius: 4,  
              spreadRadius: 0,  
            ),
          ]),
      child: Center(
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
