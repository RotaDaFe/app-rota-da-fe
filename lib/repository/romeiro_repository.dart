
import 'package:rota_da_fe/config/database_helper.dart';
import 'package:rota_da_fe/models/romeiro.model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RomeiroRepository {

  /// Exporta todos os romeiros para um arquivo CSV e retorna o caminho do arquivo gerado
  /// É necessário o pacote path_provider para obter o diretório temporário
  /// e dart:io para manipulação de arquivos.
  Future<String> exportToCsvFile() async {
    final romeiros = await getAllRomeiros();
    if (romeiros.isEmpty) {
      throw Exception('Nenhum romeiro encontrado para exportar.');
    }
    // Cabeçalho
    final headers = romeiros.first.keys.toList();
    final buffer = StringBuffer();
    buffer.writeln(headers.join(','));
    // Linhas
    for (final r in romeiros) {
      buffer.writeln(headers.map((h) => '"${r[h]?.toString().replaceAll('"', '""') ?? ''}"').join(','));
    }
    // Salva arquivo temporário
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/romeiros_export.csv');
    await file.writeAsString(buffer.toString());
    return file.path;
  }
  Future<Map<String, dynamic>?> getRomeiroByUuid(String uuid) async {
    final box = helper.getBox(boxName);
    final romeiro = box.values.firstWhere(
      (e) => e['uuid'] == uuid,
      orElse: () => null,
    );
    if (romeiro != null) {
      return Map<String, dynamic>.from(romeiro);
    }
    return null;
  }
  final HiveHelper helper;
  final String boxName = 'romeiros';
  RomeiroRepository(this.helper);

  Future<int> addRomeiro(RomeiroModel romeiro) async {
    final box = helper.getBox(boxName);
    return await box.add(romeiro.toMap());
  }

  Future<void> updateRomeiroByUuid(String uuid, RomeiroModel romeiro) async {
    final box = helper.getBox(boxName);
    final key = box.keys.firstWhere((k) => box.get(k)['uuid'] == uuid, orElse: () => null);
    if (key != null) {
      await box.put(key, romeiro.toMap());
    }
  }

  Future<void> deleteRomeiroByUuid(String uuid) async {
    final box = helper.getBox(boxName);
    final key = box.keys.firstWhere((k) => box.get(k)['uuid'] == uuid, orElse: () => null);
    if (key != null) {
      await box.delete(key);
    }
  }

  Future<List<Map<String, dynamic>>> getAllRomeiros() async {
    final box = helper.getBox(boxName);
    return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<Map<String, dynamic>?> getRomeiroById(int id) async {
    final box = helper.getBox(boxName);
    final romeiro = box.get(id);
    if (romeiro != null) {
      return Map<String, dynamic>.from(romeiro);
    }
    return null;
  }
}
