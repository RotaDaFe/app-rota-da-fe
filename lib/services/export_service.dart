import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:rota_da_fe/config/api_config.dart';
import 'package:rota_da_fe/models/export_pessoa.model.dart';
import 'package:rota_da_fe/models/romeiro.model.dart';
import 'package:rota_da_fe/repository/romeiro_repository.dart';
import 'package:rota_da_fe/services/http_method_service.dart';

class ExportService {
  static Map<String, String> _headers(String apiPassword) => {
    'accept': 'application/json',
    'x-api-password': apiPassword,
    'Content-Type': 'application/json',
  };

  static String _resolveBaseUrl(String? servidor) {
    if (servidor != null && servidor.trim().isNotEmpty) {
      return ApiConfig.normalizeBaseUrl(servidor);
    }

    try {
      final box = Hive.box('logins');
      if (box.isNotEmpty) {
        final login = box.getAt(0);
        if (login is Map) {
          return ApiConfig.normalizeBaseUrl(login['servidor']?.toString());
        }
      }
    } catch (_) {
      // O endereço de produção é usado caso o Hive ainda não esteja aberto.
    }

    return ApiConfig.productionBaseUrl;
  }

  static Future<void> _markAsSynchronized({
    required List<String> uuids,
    required List<RomeiroModel> romeiros,
    required RomeiroRepository repository,
  }) async {
    for (final uuid in uuids) {
      final romeiro = romeiros.firstWhereOrNull((item) => item.uuid == uuid);
      if (romeiro == null) continue;

      final updated = RomeiroModel(
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
      await repository.updateRomeiroByUuid(uuid, updated);
    }
  }

  /// Sincroniza cadastros novos ou alterados e retorna o status HTTP recebido.
  static Future<Map<String, dynamic>> exportarSincronizandoComApiComRetorno({
    required List<RomeiroModel> romeiros,
    required String operadorNome,
    required String operadorEmail,
    required String apiPassword,
    required RomeiroRepository repository,
    String? servidor,
  }) async {
    if (romeiros.isEmpty) {
      return {'sucesso': false, 'sincronizados': 0, 'statusCode': 404};
    }

    final baseUrl = _resolveBaseUrl(servidor);
    final headers = _headers(apiPassword);
    final uuids = romeiros.map((romeiro) => romeiro.uuid).toList();

    try {
      final syncResponse = await HttpMethodService.post(
        ApiConfig.endpoint('api/pessoa/sync', baseUrl: baseUrl),
        headers: headers,
        body: {'uuids': uuids},
      );
      print('[EXPORT] Consulta de sincronização: ${syncResponse.statusCode}');

      if (syncResponse.statusCode != 200 && syncResponse.statusCode != 201) {
        return {
          'sucesso': false,
          'sincronizados': 0,
          'statusCode': syncResponse.statusCode,
        };
      }

      final decodedSync = jsonDecode(syncResponse.body);
      if (decodedSync is! Map || decodedSync['missing'] is! List) {
        return {'sucesso': false, 'sincronizados': 0, 'statusCode': 502};
      }
      final missingUuids = List<String>.from(decodedSync['missing']);
      final hasUpdates = romeiros.any((romeiro) => romeiro.atualizado == true);

      if (missingUuids.isEmpty && !hasUpdates) {
        return {'sucesso': true, 'sincronizados': 0, 'statusCode': 200};
      }

      final pessoas = romeiros
          .where(
            (romeiro) =>
                missingUuids.contains(romeiro.uuid) ||
                romeiro.atualizado == true,
          )
          .map(
            (romeiro) => ExportPessoaModel.fromRomeiroModel(romeiro)
                .copyWith(
                  operador_nome: operadorNome,
                  operador_email: operadorEmail,
                )
                .toJson(),
          )
          .toList();

      if (pessoas.isEmpty) {
        return {'sucesso': true, 'sincronizados': 0, 'statusCode': 200};
      }

      final upsertResponse = await HttpMethodService.post(
        ApiConfig.endpoint('api/pessoa/upsert-batch', baseUrl: baseUrl),
        headers: headers,
        body: {'pessoas': pessoas},
      );
      print(
        '[EXPORT] Envio de ${pessoas.length} cadastro(s): '
        '${upsertResponse.statusCode}',
      );

      final success =
          upsertResponse.statusCode == 200 || upsertResponse.statusCode == 201;
      if (!success) {
        return {
          'sucesso': false,
          'sincronizados': 0,
          'statusCode': upsertResponse.statusCode,
        };
      }

      final decodedUpsert = jsonDecode(upsertResponse.body);
      final upserted = decodedUpsert is Map && decodedUpsert['upserted'] is List
          ? List<String>.from(decodedUpsert['upserted'])
          : <String>[];

      await _markAsSynchronized(
        uuids: upserted,
        romeiros: romeiros,
        repository: repository,
      );

      return {
        'sucesso': true,
        'sincronizados': upserted.length,
        'statusCode': upsertResponse.statusCode,
      };
    } catch (error) {
      print('[EXPORT] Falha de comunicação com a API: $error');
      return {'sucesso': false, 'sincronizados': 0, 'statusCode': 503};
    }
  }

  static Future<bool> exportarSincronizandoComApi({
    required List<RomeiroModel> romeiros,
    required String operadorNome,
    required String operadorEmail,
    required String apiPassword,
    required RomeiroRepository repository,
    String? servidor,
  }) async {
    final result = await exportarSincronizandoComApiComRetorno(
      romeiros: romeiros,
      operadorNome: operadorNome,
      operadorEmail: operadorEmail,
      apiPassword: apiPassword,
      repository: repository,
      servidor: servidor,
    );
    return result['sucesso'] == true;
  }

  static Future<bool> exportarPessoasBatch({
    required List<Map<String, dynamic>> pessoas,
    required String apiPassword,
  }) async {
    final configuredServer = pessoas.isNotEmpty
        ? pessoas.first['servidor']?.toString()
        : null;
    final sanitizedPessoas = pessoas
        .map((pessoa) => Map<String, dynamic>.from(pessoa)..remove('servidor'))
        .toList();

    try {
      final response = await HttpMethodService.post(
        ApiConfig.endpoint(
          'api/pessoa/upsert-batch',
          baseUrl: configuredServer,
        ),
        headers: _headers(apiPassword),
        body: {'pessoas': sanitizedPessoas},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> exportarDados(
    Map<String, dynamic> dados,
    String url,
  ) async {
    try {
      final response = await HttpMethodService.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: dados,
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
