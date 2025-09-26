import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:rota_da_fe/components/alerts.dart';
import 'package:rota_da_fe/components/outlinedbuttoncustom.dart';
import 'package:rota_da_fe/config/config.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/components/textfieldcustom.dart';
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/models/romeiro.model.dart';
import 'package:rota_da_fe/repository/romeiro_repository.dart';
import 'package:rota_da_fe/style/animations.dart';
import 'package:rota_da_fe/components/dropdownbuttonform.dart';
import 'package:rota_da_fe/pages/inicio.page.dart';
import 'package:rota_da_fe/services/data_service.dart';
import 'package:rota_da_fe/services/romeiro_service.dart';
import 'package:rota_da_fe/style/textstyles.dart';

class PageCadastroRomeiro extends StatefulWidget {
  const PageCadastroRomeiro({super.key});

  @override
  State<PageCadastroRomeiro> createState() => _PageCadastroRomeiroState();
}

class _PageCadastroRomeiroState extends State<PageCadastroRomeiro> {
  final Uuid uuidGen = Uuid();
  final HiveHelper dbHelper = HiveHelper();
  late final RomeiroRepository romeiroRepository;
  @override
  void initState() {
    super.initState();
    romeiroRepository = RomeiroRepository(dbHelper);
  }

  List<String> locaDeAtendimento = ConfigData().localDeAtendimento;
  List<String> sexo = ["Selecione", "Feminino", "Masculino", "Outros"];

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerIdade = TextEditingController();
  TextEditingController dropdowncontrollerCondicaoFisica =
      TextEditingController();
  TextEditingController controllerCondicaoFisica = TextEditingController();
  TextEditingController dropdownControllerLocalDeAtendimento =
      TextEditingController();
  TextEditingController dropdownControllerCidade = TextEditingController();
  TextEditingController dropdownControllerSexo = TextEditingController();
  List<String> patologiaMaisVistas = patologiasMaisVistas;
  bool inputPersonalizado = false;
  String? selectedCity;
  String? selectedLocation;
  String? gender;

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    return LayoutBase(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(children: [
                const SizedBox(height: 30),
                const Center(
                    child: Text("CADASTRO",
                        style: AppTextStyles.head1)),
                const SizedBox(height: 15),
                TextFieldCustom(
                    keyboardType: TextInputType.name,
                    labelText: "Nome",
                    controller: controllerNome,
                    width: largura),
                TextFieldCustom(
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: false, signed: false),
                    labelText: "Idade",
                    isNumber: true,
                    controller: controllerIdade,
                    width: largura),
                DropdownButtonForm(
                    onChanged: () {},
                    labelText: "Cidade",
                    items: cidades,
                    controller: dropdownControllerCidade,
                    initialValue: "Selecione",
                    width: largura),
                DropdownButtonForm(
                    onChanged: () {},
                    labelText: "Sexo",
                    items: sexo,
                    controller: dropdownControllerSexo,
                    initialValue: "Selecione",
                    width: largura),
                DropdownButtonForm(
                    onChanged: () {},
                    labelText: "Local de atendimento",
                    items: locaDeAtendimento,
                    controller: dropdownControllerLocalDeAtendimento,
                    initialValue: "Selecione",
                    width: largura),
              
                DropdownButtonForm(
                    labelText: "Condição Física",
                    items: patologiaMaisVistas,
                    controller: dropdowncontrollerCondicaoFisica,
                    initialValue: "Selecione",
                    width: largura,
                    onChanged: () {
                      setState(() {
                        inputPersonalizado =
                            dropdowncontrollerCondicaoFisica.text ==
                                "Outros";
                      });
                    }),
                inputPersonalizado
                    ? TextFieldCustom(
                        keyboardType: TextInputType.text,
                        labelText: "Condição Física",
                        controller: controllerCondicaoFisica,
                        width: largura)
                    : Container(),
                const SizedBox(height: 20),
                OutlinedButtonCustom(
                    text: "Cadastrar",
                    ontap: () async {
                      // verifica se os campos estão preenchidos
                      if (controllerNome.text.isNotEmpty &&
                          controllerIdade.text.isNotEmpty &&
                          dropdownControllerCidade.text != 'Selecione' &&
                          dropdownControllerLocalDeAtendimento.text !=
                              'Selecione' &&
                          dropdownControllerSexo.text != 'Selecione' &&
                          dropdowncontrollerCondicaoFisica.text !=
                              'Selecione' &&
                          dropdowncontrollerCondicaoFisica
                              .text.isNotEmpty &&
                          dropdownControllerLocalDeAtendimento
                              .text.isNotEmpty &&
                          dropdownControllerSexo.text.isNotEmpty) {
                        //
                        // verifica se o input personalizado ta ativado
                        if (inputPersonalizado) {
                          //
                          // veerifica se  controller CondicaoFisica tem algo
                          if (controllerCondicaoFisica.text.isEmpty) {
                            alertFailField(context);
                          } else {
                            //
                            // Caso input personalizado esteja ativado E controller esteja preenchido
                            // então rode
                            alertSucess(context);
                            // falta atualizar
                            final romeiro = RomeiroModel(
                              uuid: uuidGen.v4(),
                              nome: controllerNome.text,
                              idade: int.tryParse(controllerIdade.text) ?? 0,
                              cidade: dropdownControllerCidade.text,
                              localDeAtendimento: dropdownControllerLocalDeAtendimento.text,
                              sexo: dropdownControllerSexo.text,
                              patologia: controllerCondicaoFisica.text,
                              createdAt: DateTime.now().toIso8601String(),
                              updatedAt: DateTime.now().toIso8601String(),
                            );
                            await addRomeiro(repository: romeiroRepository, romeiro: romeiro);
                            // ignore: use_build_context_synchronously
                            navigateAndRemoveUntil(
                                context, const PageInicio());
                          }
                        } else {
                          // caso o  input personalizado esteja desativado
                          // então rodee
                          alertSucess(context);
                          // falta atualizar
                          final romeiro = RomeiroModel(
                            uuid: uuidGen.v4(),
                            nome: controllerNome.text,
                            idade: int.tryParse(controllerIdade.text) ?? 0,
                            cidade: dropdownControllerCidade.text,
                            localDeAtendimento: dropdownControllerLocalDeAtendimento.text,
                            sexo: dropdownControllerSexo.text,
                            patologia: dropdowncontrollerCondicaoFisica.text,
                            createdAt: DateTime.now().toIso8601String(),
                            updatedAt: DateTime.now().toIso8601String(),
                          );
                          await addRomeiro(repository: romeiroRepository, romeiro: romeiro);
                          // ignore: use_build_context_synchronously
                          navigateAndRemoveUntil(
                              context, const PageInicio());
                        }
                      } else {
                        alertFailField(context);
                      }
                    })
              ]),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
