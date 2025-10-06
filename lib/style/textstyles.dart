import 'package:flutter/material.dart';
import 'package:rota_da_fe/style/colors.dart';

class AppTextStyles {
  static const TextStyle head1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
    fontFamily: 'Sofia Sans',
  );
  static const TextStyle subTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.subTitle,
    fontFamily: 'Sofia Sans',
  );
  static const TextStyle navbarTitle = TextStyle(
    fontSize: 35,
    color: Color(0xff7E501E),
    fontWeight: FontWeight.bold,
    fontFamily: 'Sofia Sans Extra Condesed',
  );
  static const TextStyle inputTitle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.bold,fontFamily: 'Sofia Sans');

  // // Título de seção (ex: Romeiros cadastrados)
  // static const TextStyle head2 = TextStyle(
  //   fontSize: 22,
  //   fontWeight: FontWeight.bold,
  //   color: AppColors.secondary,
  // );

  // // Texto de botão
  // static const TextStyle button = TextStyle(
  //   fontSize: 18,
  //   fontWeight: FontWeight.w600,
  //   color: Color(0xffEDB637), // mesma cor de AppColors.primary
  // );

  // // Texto padrão/corpo
  // static const TextStyle body = TextStyle(
  //   fontSize: 18,
  //   color: Colors.black,
  // );

  // // Texto de erro/alerta
  // static const TextStyle error = TextStyle(
  //   fontSize: 16,
  //   color: Colors.red,
  //   fontWeight: FontWeight.bold,
  // );

  // // Texto pequeno (ex: subtítulo, info)
  // static const TextStyle small = TextStyle(
  //   fontSize: 14,
  //   color: Colors.black54,
  // );

  // // Texto splash/loading
  // static const TextStyle splash = TextStyle(
  //   fontSize: 20,
  //   color: Colors.black87,
  // );
}
