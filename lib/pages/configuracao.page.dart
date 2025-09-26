import 'package:share_plus/share_plus.dart';
import 'package:rota_da_fe/repository/romeiro_repository.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rota_da_fe/components/elevatedbuttoncustom.dart';
import 'package:rota_da_fe/layout.dart';
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/style/animations.dart';
import 'package:rota_da_fe/pages/editar_cadastro_user.page.dart';
import 'package:rota_da_fe/services/export_service.dart';
import 'package:hive/hive.dart';
import 'package:rota_da_fe/services/romeiro_service.dart';
import 'package:rota_da_fe/style/textstyles.dart';

class PageConfiguracao extends StatefulWidget {
  const PageConfiguracao({super.key});

  @override
  State<PageConfiguracao> createState() => _PageConfiguracaoState();
}

class _PageConfiguracaoState extends State<PageConfiguracao> {
  final HiveHelper dbHelper = HiveHelper();

  // Função para mostrar a confirmação de exportação
  Future<void> _showConfirmExportDialog(BuildContext context) async {
    // Simulação: todos com atualizado:true serão sincronizados
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Exportar dados',
      text: 'Você deseja exportar os dados do aplicativo?',
      confirmBtnText: 'Sim',
      cancelBtnText: 'Não',
      onConfirmBtnTap: () {
        Navigator.of(context).pop(); // Fechar o popup de confirmação
        _exportData(context); // Iniciar o processo de exportação
      },
    );
  }

  // Função para exportar os dados e tratar erro/sucesso
  Future<Map<String, dynamic>> exportDatabase(
      {required HiveHelper dbHelper}) async {
    final repo = RomeiroRepository(dbHelper);
    final romeiros = await getAllRomeiros(repository: repo);
    print('[EXPORT][DEBUG] Estado dos romeiros antes de exportar:');
    for (final r in romeiros) {
      print(
          '[EXPORT][DEBUG] uuid: ${r.uuid}, nome: ${r.nome}, atualizado: ${r.atualizado}');
    }
    if (romeiros.isEmpty) {
      return {'status': 404, 'sincronizados': 0}; // Nenhum romeiro cadastrado
    }
    // Busca a senha do Hive (box logins)
    final loginsBox = Hive.box('logins');
    print('[EXPORT] Chaves em loginsBox: \\${loginsBox.keys}');
    for (var k in loginsBox.keys) {
      print('[EXPORT] loginsBox[${k.toString()}] = \\${loginsBox.get(k)}');
    }
    final loginMap = loginsBox.isNotEmpty ? loginsBox.getAt(0) : null;
    final apiPassword =
        loginMap != null && loginMap is Map && loginMap.containsKey('senha')
            ? loginMap['senha']
            : '';
    final operadorNome =
        loginMap != null && loginMap is Map && loginMap.containsKey('nome')
            ? loginMap['nome']
            : '';
    final operadorEmail =
        loginMap != null && loginMap is Map && loginMap.containsKey('nome')
            ? loginMap['nome']
            : '';
    print('[EXPORT] Senha lida do Hive: "$apiPassword"');
    print('[EXPORT] Operador nome: "$operadorNome"');
    print('[EXPORT] Operador email: "$operadorEmail"');
    if (apiPassword.isEmpty) {
      print('[EXPORT] Senha não encontrada no Hive!');
      return {'status': 403, 'sincronizados': 0}; // Sem senha
    }
    // Passa RomeiroModel para ExportService, junto com operador info
    final result = await ExportService.exportarSincronizandoComApiComRetorno(
      romeiros: romeiros,
      operadorNome: operadorNome,
      operadorEmail: operadorEmail,
      apiPassword: apiPassword,
      repository: repo,
    );
    print('[EXPORT] Resultado da exportação: ${result['sucesso']}');
    return {
      'status': result['sucesso'] ? 201 : 500,
      'sincronizados': result['sincronizados'] ?? 0
    };
  }

  Future<String> exportDatabaseCopy({required HiveHelper dbHelper}) async {
    List<Map<String, dynamic>> romeiros = List<Map<String, dynamic>>.from(
        await getAllRomeiros(repository: RomeiroRepository(dbHelper)));
    if (romeiros.isEmpty) {
      return "";
    }
    return romeiros.toString();
  }

  Future<void> _exportData(BuildContext context) async {
    // Exibir popup de loading
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Exportando',
      text: 'Aguarde enquanto os dados estão sendo exportados...',
      barrierDismissible: false,
    );

    try {
      // Antes de exportar, calcular quantos estavam atualizados
      final repo = RomeiroRepository(dbHelper);
      final romeirosAntes = await getAllRomeiros(repository: repo);
      final totalCadastrados = romeirosAntes.length;
      final totalAtualizadosAntes =
          romeirosAntes.where((r) => r.atualizado == true).length;

      // Chamar a função real de exportação e verificar o status
      final exportResult = await exportDatabase(dbHelper: dbHelper);
      final int statusCode = exportResult['status'] ?? 500;
      final int totalSincronizadosAgora = exportResult['sincronizados'] ?? 0;

      // Fechar o popup de loading
      Navigator.of(context).pop();

      // Após exportar, atualizar lista
      final romeirosDepois = await getAllRomeiros(repository: repo);
      final totalSincronizados =
          romeirosDepois.where((r) => r.atualizado == false).length;
      if (statusCode == 404) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Nenhum romeiro cadastrado',
          text: 'Não há romeiros cadastrados neste dispositivo.',
        );
      } else if (statusCode == 403) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Acesso negado',
          text:
              'A senha fornecida está incorreta. Verifique e tente novamente.',
        );
      } else if (statusCode == 400) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erro nos dados',
          text:
              'Os dados parecem estar vazios ou corrompidos. Verifique e tente exportar novamente.',
        );
      } else if (statusCode == 201) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Exportação concluída',
          widget: Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            child: Text(
              'Total: $totalCadastrados\n'
              'Já sincronizados: $totalSincronizados\n'
              'Sincronizados agora: $totalSincronizadosAgora\n'
              'Atualizados/inclusos: $totalAtualizadosAntes',
              textAlign: TextAlign.left,
            ),
          ),
        );
      } else if (statusCode == 500) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erro no servidor',
          text:
              'Ocorreu um erro interno no servidor. Tente novamente mais tarde.',
        );
      } else {
        // Exibir popup de erro para outros status de erro desconhecidos
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Erro desconhecido',
          text:
              'Houve um erro inesperado ao exportar os dados. Código: $statusCode',
        );
      }
    } catch (error) {
      // Fechar o popup de loading
      Navigator.of(context).pop();

      // Exibir popup de erro
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erro na exportação',
        text: 'Houve um erro ao exportar os dados. Tente novamente.',
      );
    }
  }

  // Função para exportar os dados em CSV e baixar
  Future<void> _downloadCsv(BuildContext context) async {
    try {
      final repo = RomeiroRepository(dbHelper);
      final csvPath = await repo.exportToCsvFile();
      await Share.shareXFiles([XFile(csvPath, mimeType: 'text/csv')],
          subject: 'Exportação de Romeiros',
          text: 'Segue o arquivo CSV exportado dos romeiros.');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'CSV gerado!',
        text: 'Arquivo compartilhado com sucesso!',
      );
    } catch (error, stack) {
      print('Erro ao gerar CSV:');
      print(error);
      print(stack);
      final msg =
          error.toString().contains('Nenhum romeiro encontrado para exportar.')
              ? 'Nenhum romeiro cadastrado para exportar.'
              : 'Ocorreu um erro ao gerar o CSV. Tente novamente.\n$error';
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Erro',
        text: msg,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double margem = 100.0;

    return LayoutBase(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Configuração",
                style: AppTextStyles.head1,
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButtonCustom(
                width: largura - margem,
                ontap: () {
                  Navigator.of(context)
                      .push(SlideTransitionPage(page: const PageEditeUser()));
                },
                text: "Editar cadastro",
                textSub: "Clique e saiba mais",
                icon: Icons.edit_outlined,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButtonCustom(
                width: largura - 100,
                ontap: () {
                  _showConfirmExportDialog(context);
                },
                text: "Exportar dados",
                textSub: "Clique e saiba mais",
                icon: Icons.dashboard,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButtonCustom(
                width: largura - 100,
                ontap: () {
                  _downloadCsv(context);
                },
                text: "Baixar dados em CSV",
                textSub: "Clique para baixar os dados em formato CSV",
                icon: Icons.download,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
