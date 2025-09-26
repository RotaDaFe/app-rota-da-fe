// ignore_for_file: dead_code

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rota_da_fe/pages/splash_screen.page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Inicializa Hive e abre as boxes necessárias
  await Hive.initFlutter();
  await Hive.openBox('romeiros');
  await Hive.openBox('logins');

  FlutterNativeSplash.remove();

  // Variável para ativar/desativar o Device Preview
  bool isPreviewEnabled = false; // Mude para 'false' para desativar o preview

  isPreviewEnabled
      ? runApp(
          DevicePreview(
            enabled: isPreviewEnabled,
            builder: (context) => const MyApp(),
          ),
        )
      : runApp(MaterialApp(
          home: const SplashScreen(),
        ));
}

// device_preview settings
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery:
          true, // Necessário para o Device Preview funcionar
      locale: DevicePreview.locale(context), // Obtém a localização do preview
      builder:
          DevicePreview.appBuilder, // Constrói a interface com Device Preview
      home: const SplashScreen(),
    );
  }
}
