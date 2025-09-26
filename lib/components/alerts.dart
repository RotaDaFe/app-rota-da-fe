import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void alertSucessDelete(BuildContext context) {
  const snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Cadastro deletado com sucesso',
      message: 'Tudo certo. Continue aproveitando o app!',
      contentType: ContentType.success,
    ),
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void alertSucessUpdate(BuildContext context) {
  const snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Atualizado com sucesso',
      message:
          'Tudo certo, seu cadastro foi atualizado. Continue aproveitando o app!',
      contentType: ContentType.success,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void alertSucess(BuildContext context) {
  const snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Cadastrado com sucesso',
      message:
          'Tudo certo, seu cadastro foi um sucesso. Continue aproveitando o app!',
      contentType: ContentType.success,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

void alertFailField(BuildContext context,{String msg = 'Falha, Verifique se campos estão preenchidos.'}) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Opps, algo errado',
      message: msg,
      contentType: ContentType.failure,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

// Função para mostrar loading enquanto exporta o banco de dados
void alertLoading(BuildContext context) {
  const snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Exportando banco de dados...',
      message: 'Aguarde enquanto os dados estão sendo exportados.',
      contentType: ContentType.help, // Tipo de conteúdo de loading
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

// Função para exibir sucesso após exportação
void alertExportSuccess(BuildContext context) {
  const snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Exportação concluída!',
      message: 'Os dados foram exportados com sucesso.',
      contentType: ContentType.success,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

// Função para exibir falha após exportação
void alertExportFail(BuildContext context) {
  const snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Falha na exportação!',
      message: 'Houve um erro ao exportar os dados. Tente novamente.',
      contentType: ContentType.failure,
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}