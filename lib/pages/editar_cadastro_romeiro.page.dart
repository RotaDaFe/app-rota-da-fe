import 'package:rota_da_fe/components/alerts.dart';
import 'package:rota_da_fe/repository/romeiro_repository.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/style/animations.dart';
import 'package:rota_da_fe/pages/inicio.page.dart';
import 'package:rota_da_fe/services/data_service.dart';
import 'package:rota_da_fe/services/romeiro_service.dart';
import 'package:rota_da_fe/models/romeiro.model.dart';
import 'package:rota_da_fe/components/textfieldcustom.dart';
import 'package:rota_da_fe/components/dropdownbuttonform.dart';
import 'package:rota_da_fe/components/outlinedbuttoncustom.dart';
import 'package:rota_da_fe/style/textstyles.dart';

class PageEditarCadastroRomeiro extends StatefulWidget {
  final String uuid;

  const PageEditarCadastroRomeiro({required this.uuid, super.key});

  @override
  State<PageEditarCadastroRomeiro> createState() =>
      _PageEditarCadastroRomeiroState();
}

class _PageEditarCadastroRomeiroState extends State<PageEditarCadastroRomeiro> {
  final HiveHelper dbHelper = HiveHelper();
  bool isLoading = true;
  List<String> locaDeAtendimento = ["Selecione", "casa de placido", "tribunal"];
  List<String> sexo = ["Selecione", "Feminino", "Masculino", "Outros"];

  TextEditingController controllerNome = TextEditingController();
  TextEditingController controllerIdade = TextEditingController();
  TextEditingController dropdownControllerLocalDeAtendimento =
      TextEditingController();
  TextEditingController dropdownControllerCidade = TextEditingController();
  TextEditingController dropdownControllerSexo = TextEditingController();
  TextEditingController dropdowncontrollerCondicaoFisica =
      TextEditingController();
  TextEditingController controllerCondicaoFisica = TextEditingController();
  bool inputPersonalizado = false;
  late final RomeiroRepository romeiroRepository;

  @override
  void initState() {
    super.initState();
    romeiroRepository = RomeiroRepository(dbHelper);
    _loadRomeiroData();
  }

  Future<void> _loadRomeiroData() async {
    final romeiroData = await getRomeiroByUuid(
      repository: romeiroRepository,
      uuid: widget.uuid,
    );
    if (romeiroData == null) return;

    var condicaoFisica = romeiroData.patologia;
    if (patologiasMaisVistas.contains(condicaoFisica)) {
      setState(() {
        dropdowncontrollerCondicaoFisica.text = condicaoFisica;
        inputPersonalizado = false;
      });
    } else {
      setState(() {
        dropdowncontrollerCondicaoFisica.text = "Outros";
        controllerCondicaoFisica.text = condicaoFisica;
        inputPersonalizado = true;
      });
    }
    setState(() {
      controllerNome.text = romeiroData.nome;
      controllerIdade.text = romeiroData.idade.toString();
      dropdownControllerCidade.text = romeiroData.cidade;
      dropdownControllerLocalDeAtendimento.text =
          romeiroData.localDeAtendimento;
      dropdownControllerSexo.text = romeiroData.sexo;
      isLoading = false;
    });
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Confirmar exclusão',
      text: 'Tem certeza que deseja deletar este romeiro?',
      confirmBtnText: 'Sim',
      cancelBtnText: 'Não',
      onConfirmBtnTap: () async {
        await deleteRomeiro(repository: romeiroRepository, uuid: widget.uuid);
        alertSucessDelete(context);
        Navigator.pop(context);
        navigateAndRemoveUntil(context, const PageInicio());
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    return LayoutBase(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            "Editar Cadastro de Romeiro",
                            style: AppTextStyles.head1,
                          ),
                        ),
                        const Center(
                            child: Text(
                                "Atualize seus dados quando necessário.",
                                style: AppTextStyles.subTitle,
                                textAlign: TextAlign.center)),
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
                            items: cidades, // Lista de opções
                            controller: dropdownControllerCidade,
                            initialValue:
                                dropdownControllerCidade.text.isNotEmpty
                                    ? dropdownControllerCidade.text
                                    : "Selecione",
                            width: largura),
                        DropdownButtonForm(
                            onChanged: () {},
                            labelText: "Sexo",
                            items: sexo, // Lista de opções
                            controller: dropdownControllerSexo,
                            initialValue: dropdownControllerSexo.text.isNotEmpty
                                ? dropdownControllerSexo.text
                                : "Selecione",
                            width: largura),
                        DropdownButtonForm(
                            onChanged: () {},
                            labelText: "Local de atendimento",
                            items: locaDeAtendimento, // Lista de opções
                            controller: dropdownControllerLocalDeAtendimento,
                            initialValue: dropdownControllerLocalDeAtendimento
                                    .text.isNotEmpty
                                ? dropdownControllerLocalDeAtendimento.text
                                : "Selecione",
                            width: largura),
                        DropdownButtonForm(
                            labelText: "Condição Física",
                            items: patologiasMaisVistas, // Lista de opções
                            controller: dropdowncontrollerCondicaoFisica,
                            initialValue:
                                dropdowncontrollerCondicaoFisica.text.isNotEmpty
                                    ? dropdowncontrollerCondicaoFisica.text
                                    : "Selecione",
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
                            text: "Atualizar",
                            ontap: () async {
                              if (controllerNome.text.isNotEmpty &&
                                  controllerIdade.text.isNotEmpty &&
                                  dropdownControllerCidade.text !=
                                      'Selecione' &&
                                  dropdownControllerLocalDeAtendimento.text !=
                                      'Selecione' &&
                                  dropdownControllerSexo.text != 'Selecione' &&
                                  dropdowncontrollerCondicaoFisica.text !=
                                      'Selecione') {
                                // verifica se o input personalizado ta ativado
                                String patologiaFinal = inputPersonalizado
                                    ? controllerCondicaoFisica.text
                                    : dropdowncontrollerCondicaoFisica.text;
                                if (inputPersonalizado &&
                                    controllerCondicaoFisica.text.isEmpty) {
                                  alertFailField(context);
                                } else {
                                  alertSucess(context);
                                  RomeiroModel romeiroAtualizado = RomeiroModel(
                                    uuid: widget.uuid,
                                    nome: controllerNome.text,
                                    idade: int.parse(controllerIdade.text),
                                    cidade: dropdownControllerCidade.text,
                                    localDeAtendimento:
                                        dropdownControllerLocalDeAtendimento
                                            .text,
                                    sexo: dropdownControllerSexo.text,
                                    patologia: patologiaFinal,
                                  );
                                  await updateRomeiro(
                                    repository: romeiroRepository,
                                    uuid: widget.uuid,
                                    romeiro: romeiroAtualizado,
                                  );
                                  // ignore: use_build_context_synchronously
                                  navigateAndRemoveUntil(
                                      context, const PageInicio());
                                }
                              } else {
                                alertFailField(context);
                              }
                            }),
                        const SizedBox(height: 20),
                        // Botão de deletar romeiro
                        OutlinedButtonCustom(
                          text: "Deletar",
                          ontap: () async {
                            _showDeleteConfirmation(context);
                          },
                          color: const Color.fromARGB(
                              218, 244, 67, 54), // Botão vermelho
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}
