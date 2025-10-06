import 'dart:convert';
import 'package:rota_da_fe/repository/romeiro_repository.dart';
import 'package:rota_da_fe/models/export_pessoa.model.dart';
import 'package:rota_da_fe/models/romeiro.model.dart';
import 'package:rota_da_fe/services/http_method_service.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';

class ExportService {
  /// Versão que retorna o total de sincronizados/upserted
  static Future<Map<String, dynamic>> exportarSincronizandoComApiComRetorno({
    required List<RomeiroModel> romeiros,
    required String operadorNome,
    required String operadorEmail,
    required String apiPassword,
    required RomeiroRepository repository,
    String? servidor,
  }) async {
    if (romeiros.isEmpty) {
      print('[EXPORT] Nenhum romeiro para exportar.');
      return {'sucesso': false, 'sincronizados': 0};
    }
    // Buscar servidor do Hive se não informado
    String baseUrl = servidor ?? '';
    if (baseUrl.isEmpty) {
      try {
        final box = Hive.box('logins');
        if (box.isNotEmpty) {
          final loginMap = box.getAt(0);
          if (loginMap != null && loginMap is Map && loginMap.containsKey('servidor')) {
            baseUrl = loginMap['servidor'] ?? 'https://api-rtf.nextlab.cloud/';
          } else {
            baseUrl = 'https://api-rtf.nextlab.cloud/';
          }
        } else {
          baseUrl = 'https://api-rtf.nextlab.cloud/';
        }
      } catch (e) {
        baseUrl = 'https://api-rtf.nextlab.cloud/';
      }
    }
    // 1. Coletar todos os UUIDs locais
    final uuids = romeiros.map((r) => r.uuid).toList();
    print('[EXPORT] UUIDs locais: $uuids');
    // 2. Fazer o fetch para saber quais estão faltando na base remota
    final String syncUrl = baseUrl + 'api/pessoa/sync';
    print('[EXPORT] Usando servidor: $baseUrl');
    print('[EXPORT] Enviando para $syncUrl com senha: "$apiPassword"');
    final syncResponse = await HttpMethodService.post(
      syncUrl,
      headers: {
        'accept': 'application/json',
        'x-api-password': apiPassword,
        'Content-Type': 'application/json',
      },
      body: {'uuids': uuids},
    );
    print('[EXPORT] Status sync: ${syncResponse.statusCode}');
    print('[EXPORT] Body sync: ${syncResponse.body}');
    if (syncResponse.statusCode != 201) return {'sucesso': false, 'sincronizados': 0};
    final syncData = syncResponse.body;
    final missingUuids = <String>[];
    try {
      final decoded = jsonDecode(syncData);
      if (decoded is Map && decoded['missing'] is List) {
        missingUuids.addAll(List<String>.from(decoded['missing']));
      }
    } catch (e) {
      print('[EXPORT] Erro ao decodificar syncData: $e');
      return {'sucesso': false, 'sincronizados': 0};
    }
    print('[EXPORT] UUIDs faltando na base remota: $missingUuids');
    // Se não há missing, mas há registros atualizados, exporta mesmo assim
    final temAtualizados = romeiros.any((r) => r.atualizado == true);
    if (missingUuids.isEmpty && !temAtualizados) {
      print('[EXPORT] Nada a exportar.');
      return {'sucesso': true, 'sincronizados': 0};
    }
    // 3. Filtrar os dados locais para enviar os que faltam OU foram atualizados
    final pessoasParaExportar = romeiros
      .where((r) => missingUuids.contains(r.uuid) || r.atualizado == true)
      .map((r) => ExportPessoaModel.fromRomeiroModel(r).copyWith(
          operador_nome: operadorNome,
          operador_email: operadorEmail,
        ).toJson())
      .toList();
    print('[EXPORT] Pessoas para exportar: $pessoasParaExportar');
    if (pessoasParaExportar.isEmpty) {
      print('[EXPORT] Nenhuma pessoa para exportar após filtro.');
      return {'sucesso': true, 'sincronizados': 0};
    }
    // 4. Enviar para o endpoint de upsert-batch
    final String upsertUrl = baseUrl + 'api/pessoa/upsert-batch';
    final jsonBody = jsonEncode({'pessoas': pessoasParaExportar});
    print('[EXPORT] JSON serializado enviado para upsert: $jsonBody');
    try {
      final upsertResponse = await HttpMethodService.post(
        upsertUrl,
        headers: {
          'accept': '*/*',
          'x-api-password': apiPassword,
          'Content-Type': 'application/json',
        },
        body: {'pessoas': pessoasParaExportar},
      );
      print('[EXPORT] Status upsert: \\${upsertResponse.statusCode}');
      print('[EXPORT] Body upsert: \\${upsertResponse.body}');
      if (upsertResponse.statusCode != 200 && upsertResponse.statusCode != 201) {
        print('[EXPORT] Falha ao exportar! Status: \\${upsertResponse.statusCode}, Body: \\${upsertResponse.body}');
      }
      final sucesso = upsertResponse.statusCode == 200 || upsertResponse.statusCode == 201;
      int totalSincronizados = 0;
      // Se exportou com sucesso, marcar atualizado:false para os exportados
      if (sucesso) {
        // Tenta pegar os uuids exportados do body
        try {
          final upsertBody = upsertResponse.body;
          final decoded = jsonDecode(upsertBody);
          if (decoded is Map && decoded['upserted'] is List) {
            final uuidsExportados = List<String>.from(decoded['upserted']);
            totalSincronizados = uuidsExportados.length;
            for (final uuid in uuidsExportados) {
              final romeiro = romeiros.firstWhereOrNull((r) => r.uuid == uuid);
              if (romeiro != null) {
                final repo = repository;
                final romeiroAtualizado = RomeiroModel(
                  uuid: romeiro.uuid,
                  nome: romeiro.nome,
                  idade: romeiro.idade,
                  cidade: romeiro.cidade,
                  localDeAtendimento: romeiro.localDeAtendimento,
                  sexo: romeiro.sexo,
                  patologia: romeiro.patologia,
                  atualizado: false,
                  createdAt: romeiro.createdAt,
                  updatedAt: romeiro.updatedAt,
                );
                await repo.updateRomeiroByUuid(romeiro.uuid, romeiroAtualizado);
                print('[EXPORT] Marcou atualizado:false para uuid: ${romeiro.uuid}');
              }
            }
          }
        } catch (e) {
          print('[EXPORT] Erro ao marcar atualizado:false: $e');
        }
      }
      return {'sucesso': sucesso, 'sincronizados': totalSincronizados};
    } catch (e, s) {
      print('[EXPORT] Erro inesperado no upsert: $e');
      print('[EXPORT] Stack: $s');
      return {'sucesso': false, 'sincronizados': 0};
    }
  }
  /// Sincroniza os dados locais com a API remota, enviando apenas os registros que não existem na base remota ou foram atualizados
  static Future<bool> exportarSincronizandoComApi({
    required List<RomeiroModel> romeiros,
    required String operadorNome,
    required String operadorEmail,
    required String apiPassword,
    required RomeiroRepository repository,
  String? servidor,
  }) async {
    if (romeiros.isEmpty) {
      print('[EXPORT] Nenhum romeiro para exportar.');
      return false;
    }
    // Buscar servidor do Hive se não informado
    String baseUrl = servidor ?? '';
    if (baseUrl.isEmpty) {
      try {
        final box = Hive.box('logins');
        if (box.isNotEmpty) {
          final loginMap = box.getAt(0);
          if (loginMap != null && loginMap is Map && loginMap.containsKey('servidor')) {
            baseUrl = loginMap['servidor'] ?? 'https://api-rtf.nextlab.cloud/';
          } else {
            baseUrl = 'https://api-rtf.nextlab.cloud/';
          }
        } else {
          baseUrl = 'https://api-rtf.nextlab.cloud/';
        }
      } catch (e) {
        baseUrl = 'https://api-rtf.nextlab.cloud/';
      }
    }
    // 1. Coletar todos os UUIDs locais
    final uuids = romeiros.map((r) => r.uuid).toList();
    print('[EXPORT] UUIDs locais: $uuids');
    // 2. Fazer o fetch para saber quais estão faltando na base remota
    final String syncUrl = baseUrl + 'api/pessoa/sync';
    print('[EXPORT] Usando servidor: $baseUrl');
    print('[EXPORT] Enviando para $syncUrl com senha: "$apiPassword"');
    final syncResponse = await HttpMethodService.post(
      syncUrl,
      headers: {
        'accept': 'application/json',
        'x-api-password': apiPassword,
        'Content-Type': 'application/json',
      },
      body: {'uuids': uuids},
    );
    print('[EXPORT] Status sync: ${syncResponse.statusCode}');
    print('[EXPORT] Body sync: ${syncResponse.body}');
    if (syncResponse.statusCode != 201) return false;
    final syncData = syncResponse.body;
    final missingUuids = <String>[];
    try {
      final decoded = jsonDecode(syncData);
      if (decoded is Map && decoded['missing'] is List) {
        missingUuids.addAll(List<String>.from(decoded['missing']));
      }
    } catch (e) {
      print('[EXPORT] Erro ao decodificar syncData: $e');
      return false;
    }
    print('[EXPORT] UUIDs faltando na base remota: $missingUuids');
    // Se não há missing, mas há registros atualizados, exporta mesmo assim
    final temAtualizados = romeiros.any((r) => r.atualizado == true);
    if (missingUuids.isEmpty && !temAtualizados) {
      print('[EXPORT] Nada a exportar.');
      return true;
    }
    // 3. Filtrar os dados locais para enviar os que faltam OU foram atualizados
  final pessoasParaExportar = romeiros
    .where((r) => missingUuids.contains(r.uuid) || r.atualizado == true)
    .map((r) => ExportPessoaModel.fromRomeiroModel(r).copyWith(
        operador_nome: operadorNome,
        operador_email: operadorEmail,
      ).toJson())
    .toList();
    print('[EXPORT] Pessoas para exportar: $pessoasParaExportar');
    if (pessoasParaExportar.isEmpty) {
      print('[EXPORT] Nenhuma pessoa para exportar após filtro.');
      return true;
    }
    // 4. Enviar para o endpoint de upsert-batch
  final String upsertUrl = baseUrl + 'api/pessoa/upsert-batch';
  final jsonBody = jsonEncode({'pessoas': pessoasParaExportar});
  print('[EXPORT] JSON serializado enviado para upsert: $jsonBody');
    try {
      final upsertResponse = await HttpMethodService.post(
        upsertUrl,
        headers: {
          'accept': '*/*',
          'x-api-password': apiPassword,
          'Content-Type': 'application/json',
        },
        body: {'pessoas': pessoasParaExportar},
      );
      print('[EXPORT] Status upsert: \\${upsertResponse.statusCode}');
      print('[EXPORT] Body upsert: \\${upsertResponse.body}');
      if (upsertResponse.statusCode != 200 && upsertResponse.statusCode != 201) {
        print('[EXPORT] Falha ao exportar! Status: \\${upsertResponse.statusCode}, Body: \\${upsertResponse.body}');
      }
      final sucesso = upsertResponse.statusCode == 200 || upsertResponse.statusCode == 201;
      print('[EXPORT] Sucesso upsert? $sucesso');
      // Se exportou com sucesso, marcar atualizado:false para os exportados
      if (sucesso) {
        // Tenta pegar os uuids exportados do body
        try {
          final upsertBody = upsertResponse.body;
          final decoded = jsonDecode(upsertBody);
          if (decoded is Map && decoded['upserted'] is List) {
            final uuidsExportados = List<String>.from(decoded['upserted']);
            for (final uuid in uuidsExportados) {
              final romeiro = romeiros.firstWhere((r) => r.uuid == uuid && r.atualizado == true,);
              final repo = repository;
              final romeiroAtualizado = RomeiroModel(
                uuid: romeiro.uuid,
                nome: romeiro.nome,
                idade: romeiro.idade,
                cidade: romeiro.cidade,
                localDeAtendimento: romeiro.localDeAtendimento,
                sexo: romeiro.sexo,
                patologia: romeiro.patologia,
                atualizado: false,
                createdAt: romeiro.createdAt,
                updatedAt: romeiro.updatedAt,
              );
              await repo.updateRomeiroByUuid(romeiro.uuid, romeiroAtualizado);
              print('[EXPORT] Marcou atualizado:false para uuid: ${romeiro.uuid}');
            }
          }
        } catch (e) {
          print('[EXPORT] Erro ao marcar atualizado:false: $e');
        }
      }
      return sucesso;
    } catch (e, s) {
      print('[EXPORT] Erro inesperado no upsert: $e');
      print('[EXPORT] Stack: $s');
      return false;
    }
  }

  // Não é mais necessário _toApiMap, pois ExportPessoaModel já faz a conversão
  // Exporta um batch de pessoas para a API na nuvem
  static Future<bool> exportarPessoasBatch({
    required List<Map<String, dynamic>> pessoas,
    required String apiPassword,
  }) async {
    final String url = (pessoas.isNotEmpty && pessoas.first.containsKey('servidor'))
      ? pessoas.first['servidor'] + 'api/pessoa/upsert-batch'
      : 'https://api-rtf.nextlab.cloud/api/pessoa/upsert-batch';
    try {
      final response = await HttpMethodService.post(
        url,
        headers: {
          'accept': '*/*',
          'x-api-password': apiPassword,
          'Content-Type': 'application/json',
        },
        body: {'pessoas': pessoas},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Exemplo genérico
  static Future<bool> exportarDados(Map<String, dynamic> dados, String url) async {
    try {
      final response = await HttpMethodService.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: dados,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
