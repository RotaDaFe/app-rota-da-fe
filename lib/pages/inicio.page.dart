import 'package:flutter/material.dart';
import 'package:rota_da_fe/components/totalusersbanner.dart';
import 'package:rota_da_fe/components/elevatedbuttoncustom.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/components/sectionlogoextensao.dart';
import 'package:rota_da_fe/components/walpaperbackground.dart';
import 'package:rota_da_fe/config/config.dart';
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/repository/romeiro_repository.dart';
import 'package:rota_da_fe/services/romeiro_service.dart';
import 'package:rota_da_fe/style/animations.dart';
import 'package:rota_da_fe/pages/cadastro_romeiro.page.dart';
import 'package:rota_da_fe/pages/configuracao.page.dart';
import 'package:rota_da_fe/pages/mostraCadastros.page.dart';
import 'package:rota_da_fe/pages/sobre.page.dart';

class PageInicio extends StatefulWidget {
  const PageInicio({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageInicioState createState() => _PageInicioState();
}

class _PageInicioState extends State<PageInicio> {
  final HiveHelper dbHelper = HiveHelper();
  late final RomeiroRepository romeiroRepository;

  @override
  void initState() {
    super.initState();
    romeiroRepository = RomeiroRepository(dbHelper);
  }

  Future<int> _getUserCount() async {
    final usuarios = await getAllRomeiros(repository: romeiroRepository);
    return usuarios.length;
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double margem = 100.0;

    return LayoutBase(
      disableMargem: true,
      disableHomeNav: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<int>(
              future: _getUserCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar dados.'));
                } else {
                  return WalpaperBackground(
                    image: ConfigData().imagemHomePage,
                    child: TotalUsersBanner(
                      text: snapshot.data.toString(),  
                      width:
                          largura > 400.0 ? 400.0 - 50 : (largura - margem),
                    ),
                  );
                }
              },
            ),
            SizedBox(
              width: (largura > 400 ? 400 - 50 : (largura - margem)),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButtonCustom(
                      width: largura - margem,
                      ontap: () {
                        Navigator.of(context).push(SlideTransitionPage(
                            page: const PageCadastroRomeiro()));
                      },
                      text: "Cadastrar participantes",
                      textSub: "Clique e saiba mais",
                      icon: Icons.group_add,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButtonCustom(
                      width: largura - 100,
                      ontap: () {
                        Navigator.of(context).push(SlideTransitionPage(
                            page: const PageMostraCadastros()));
                      },
                      text: "Visualizar cadastros",
                      textSub: "Clique e saiba mais",
                      icon: Icons.dashboard,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButtonCustom(
                      width: largura - 100,
                      ontap: () {
                        Navigator.of(context).push(SlideTransitionPage(
                            page: PageSobreApp()));
                      },
                      text: "Sobre o app",
                      textSub: "Clique e saiba mais",
                      icon: Icons.view_timeline,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButtonCustom(
                      width: largura - 100,
                      ontap: () {
                        Navigator.of(context).push(SlideTransitionPage(
                            page: const PageConfiguracao()));
                      },
                      text: "Configuração",
                      textSub: "Clique e saiba mais",
                      icon: Icons.settings,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SectionLogoExtensao(),
            const SizedBox(height: 15),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
