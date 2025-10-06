import 'package:rota_da_fe/components/alerts.dart';
import 'package:rota_da_fe/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:rota_da_fe/components/textfieldcustom.dart';
import 'package:rota_da_fe/components/outlinedbuttoncustom.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/style/animations.dart';
import 'package:rota_da_fe/pages/inicio.page.dart';
import 'package:rota_da_fe/services/user_service.dart';
import 'package:rota_da_fe/style/textstyles.dart';

class PageInit extends StatefulWidget {
  const PageInit({super.key});

  @override
  State<PageInit> createState() => _PageInitState();
}

class _PageInitState extends State<PageInit> {
  HiveHelper dbHelper = HiveHelper();
  List<String> locaDeAtendimento = ["Selecione", "casa de placido", "tribunal"];
  List<String> sexo = ["Selecione", "Feminino", "Masculino", "Outros"];

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerBloco = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController dropdownControllerLocalDeAtendimento =
      TextEditingController();
  TextEditingController dropdownControllerCidade = TextEditingController();
  TextEditingController dropdownControllerSexo = TextEditingController();
  String? selectedCity;
  String? selectedLocation;
  String? gender;
  final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}");
  bool skipConfigServidor = false;
  TextEditingController controllerServidor =
      TextEditingController(text: 'https://api-rtf.nextlab.cloud/');
  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    return LayoutBase(
      disableIcon: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Column(children: [
                const SizedBox(height: 30),
                const Center(
                    child: Text(
                  "Cadastro inicial",
                  style: AppTextStyles.head1,
                )),
                const Center(
                    child: Text("✨ Bem-vindo ao sistema Rota da Fé!",
                        style: AppTextStyles.subTitle,
                        textAlign: TextAlign.center)),
                const SizedBox(height: 15),
                Container(height: 200,width: largura-100,decoration: BoxDecoration(
                  image: const DecorationImage(fit: BoxFit.fitWidth,image: AssetImage('images/init/background.png')),
                  borderRadius: BorderRadius.circular(10),
                ),),
                const SizedBox(height: 15),
                TextFieldCustom(
                    keyboardType: TextInputType.emailAddress,
                    labelText: "Email",
                    controller: controllerEmail,
                    width: largura),
                TextFieldCustom(
                    keyboardType: TextInputType.text,
                    labelText: "Bloco",
                    controller: controllerBloco,
                    width: largura),
                Row(
                  children: [
                    Checkbox(
                      value: skipConfigServidor,
                      onChanged: (val) {
                        setState(() {
                          skipConfigServidor = val ?? false;
                          if (skipConfigServidor) controllerSenha.clear();
                        });
                      },
                    ),
                    const Text("Informar configurações de acesso"),
                  ],
                ),
                if (skipConfigServidor)
                  TextFieldCustom(
                      keyboardType: TextInputType.url,
                      labelText: "Servidor (URL base)",
                      controller: controllerServidor,
                      width: largura),
                if (skipConfigServidor)
                  TextFieldCustom(
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      labelText: "Senha",
                      controller: controllerSenha,
                      width: largura),
                const SizedBox(height: 20),
                OutlinedButtonCustom(
                    text: "Iniciar app",
                    ontap: () async {
                      if (controllerEmail.text.isNotEmpty &&
                          controllerBloco.text.isNotEmpty) {
                        if (!emailRegex.hasMatch(controllerEmail.text)) {
                          alertFailField(context, msg: 'E-mail inválido!');
                          return;
                        }
                        print('Botão iniciar app pressionado');
                        await addUser(
                          repository: UserRepository(dbHelper),
                          nome: controllerEmail.text,
                          posto: controllerBloco.text,
                          senha:
                              !skipConfigServidor ? '' : controllerSenha.text,
                          servidor: !skipConfigServidor
                              ? ''
                              : controllerServidor.text,
                        );
                        print('Usuário adicionado, navegando para PageInicio');
                        navigateAndRemoveUntil(context, const PageInicio());
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
