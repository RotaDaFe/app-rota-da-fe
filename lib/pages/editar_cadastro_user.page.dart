import 'package:rota_da_fe/components/textfieldcustom.dart';
import 'package:rota_da_fe/components/alerts.dart';
import 'package:rota_da_fe/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:rota_da_fe/components/outlinedbuttoncustom.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/services/user_service.dart';
import 'package:rota_da_fe/style/textstyles.dart';

class PageEditeUser extends StatefulWidget {
  const PageEditeUser({super.key});

  @override
  State<PageEditeUser> createState() => _PageEditeUserState();
}

class _PageEditeUserState extends State<PageEditeUser> {
  HiveHelper dbHelper = HiveHelper();
  List<String> locaDeAtendimento = ["Selecione", "casa de placido", "tribunal"];
  List<String> sexo = ["Selecione", "Feminino", "Masculino", "Outros"];

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerBloco = TextEditingController();
  TextEditingController controllerSenha = TextEditingController();
  TextEditingController controllerServidor = TextEditingController(text: 'https://api-rotadafe.netlify.app/');
  TextEditingController dropdownControllerLocalDeAtendimento = TextEditingController();
  TextEditingController dropdownControllerCidade = TextEditingController();
  TextEditingController dropdownControllerSexo = TextEditingController();
  String? selectedCity;
  String? selectedLocation;
  String? gender;

  int? userKey;
  @override
  void initState() {
    super.initState();
    final box = dbHelper.getBox('logins');
    if (box.isNotEmpty) {
      // Busca o primeiro usuário e sua chave
      final entry = box.toMap().entries.first;
      userKey = entry.key;
      final user = entry.value;
      setState(() {
        controllerEmail.text = user['nome'] ?? '';
        controllerBloco.text = user['posto'] ?? '';
        controllerSenha.text = user['senha'] ?? '';
        controllerServidor.text = user['servidor'] ?? 'https://api-rotadafe.netlify.app/';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    return LayoutBase(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
                child: Text("CADASTRO",
                    style: AppTextStyles.head1)),
            const SizedBox(height: 15),
      TextFieldCustom(
        enabled: false,
        keyboardType: TextInputType.emailAddress,
        labelText: "Email",
        controller: controllerEmail,
        width: largura),
      TextFieldCustom(
        keyboardType: TextInputType.text,
        labelText: "Bloco",
        controller: controllerBloco,
        width: largura),
      TextFieldCustom(
        keyboardType: TextInputType.text,
        obscureText: true,
        labelText: "Senha",
        controller: controllerSenha,
        width: largura),
      TextFieldCustom(
        keyboardType: TextInputType.url,
        labelText: "Servidor (URL base)",
        controller: controllerServidor,
        width: largura),
            const SizedBox(height: 20),
            OutlinedButtonCustom(
                text: "Editar cadastro",
                ontap: () async {
                  if (controllerEmail.text.isNotEmpty &&
                      controllerBloco.text.isNotEmpty &&
                      controllerSenha.text.isNotEmpty) {
                    if (userKey != null) {
                      alertSucessUpdate(context);
                      await updateUser(
                        repository: UserRepository(dbHelper),
                        id: userKey!,
                        nome: controllerEmail.text,
                        posto: controllerBloco.text,
                        senha: controllerSenha.text,
                        servidor: controllerServidor.text,
                      );
                      Navigator.of(context).pop();
                    } else {
                      alertFailField(context, msg: 'Usuário não encontrado para editar.');
                    }
                  } else {
                    alertFailField(context);
                  }
                }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
