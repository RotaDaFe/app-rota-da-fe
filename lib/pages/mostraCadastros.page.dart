import 'package:rota_da_fe/repository/romeiro_repository.dart';
import 'package:flutter/material.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/components/usercard.dart';
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/style/animations.dart';
import 'package:rota_da_fe/pages/editar_cadastro_romeiro.page.dart';
import 'package:rota_da_fe/services/romeiro_service.dart';
import 'package:rota_da_fe/style/textstyles.dart';

class PageMostraCadastros extends StatefulWidget {
  const PageMostraCadastros({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PageMostraCadastrosState createState() => _PageMostraCadastrosState();
}

class _PageMostraCadastrosState extends State<PageMostraCadastros> {
  final HiveHelper dbHelper =
    HiveHelper();  
  List<dynamic> usuarios = [];  
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();  
  }

  Future<void> _loadUsers() async {
    setState(() { isLoading = true; });
    final data = await getAllRomeiros(repository: RomeiroRepository(dbHelper));
    setState(() {
      usuarios = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double margem = 100.0;

    return LayoutBase(
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : usuarios.isEmpty
              ? const Center(
                  child: Text(
                    "Nenhum romeiro cadastrado.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                          child: SizedBox(height: 30)),
                      const SliverToBoxAdapter(
                          child: Center(
                        child: Text("Romeiros cadastrados",
                            style: AppTextStyles.head1,textAlign: TextAlign.center),
                      )),
                      const SliverToBoxAdapter(
                          child: SizedBox(height: 30)),
                      SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          childCount: usuarios.length,
                          (context, index) {
                            final user = usuarios[index];
                            return UserCard(
                              ontap: () {
                                Navigator.of(context)
                                    .push(SlideTransitionPage(
                                        page: PageEditarCadastroRomeiro(
                                            uuid: user.uuid)))
                                    .then((_) {
                                  _loadUsers();
                                });
                              },
                              width: (largura - margem - 10) / 2,
                              nome: user.nome,
                              idade: user.idade,
                              sexo: user.sexo,
                              cidade: user.cidade,
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 40),
                      )
                    ],
                  ),
                ),
    );
  }
}
