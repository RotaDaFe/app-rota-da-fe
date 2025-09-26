import 'package:flutter/material.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/components/sectionlogoextensao.dart';
import 'package:rota_da_fe/components/sectionwithtitleandimage.dart';
import 'package:rota_da_fe/config/config.dart';

// ignore: constant_identifier_names, must_be_immutable
class PageSobreApp extends StatelessWidget {
  PageSobreApp({super.key});
  ConfigData configData = ConfigData();

  

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double margem = 100.0;
    return LayoutBase(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: largura - margem,
              child: Column(children: [
                SectionWithTitleAndImage(title: "Sobre", text: configData.rodapeTexto),
                SectionWithTitleAndImage(
                    image: configData.imagemAboutPage,
                    title: "Nossa motivação",
                    text:
                        "A fé do Círio de Nazaré nos inspira a aprimorar a experiência dos romeiros. O Rota da Fé une tradição e tecnologia para facilitar a jornada com uma ferramenta simples e eficiente. Nosso compromisso é garantir segurança e respeito à devoção, sempre evoluindo para ser um aliado na espiritualidade e bem-estar dos participantes."),
                const SizedBox(height: 15),
                SectionLogoExtensao(),
                const SizedBox(height: 15),
                SectionWithTitleAndImage(title: "Equipe", text: configData.equipe),
                const SizedBox(height: 100),
              ]),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
