import 'package:rota_da_fe/models/romeiro.model.dart';
import 'package:rota_da_fe/repository/romeiro_repository.dart';

Future<RomeiroModel?> getRomeiroByUuid({
  required RomeiroRepository repository,
  required String uuid,
}) async {
  final res = await repository.getRomeiroByUuid(uuid);
  if (res != null) {
    return RomeiroModel.fromMap(res);
  }
  return null;
}

// Adicionar Romeiro
Future<int> addRomeiro({
  required RomeiroRepository repository,
  required RomeiroModel romeiro,
}) async {
  return await repository.addRomeiro(romeiro);
}

// Deletar Romeiro por uuid
Future<void> deleteRomeiro({
  required RomeiroRepository repository,
  required String uuid,
}) async {
  await repository.deleteRomeiroByUuid(uuid);
}

// Atualizar Romeiro por uuid
Future<void> updateRomeiro({
  required RomeiroRepository repository,
  required String uuid,
  required RomeiroModel romeiro,
}) async {
  // Sempre marca como atualizado ao editar
  final romeiroAtualizado = RomeiroModel(
    uuid: romeiro.uuid,
    nome: romeiro.nome,
    idade: romeiro.idade,
    cidade: romeiro.cidade,
    localDeAtendimento: romeiro.localDeAtendimento,
    sexo: romeiro.sexo,
    patologia: romeiro.patologia,
    atualizado: true,
    createdAt: romeiro.createdAt,
    updatedAt: romeiro.updatedAt,
  );
  await repository.updateRomeiroByUuid(uuid, romeiroAtualizado);
}

// Buscar todos os Romeiros
Future<List<RomeiroModel>> getAllRomeiros({required RomeiroRepository repository}) async {
  final data = await repository.getAllRomeiros();
  return data.map<RomeiroModel>((e) => RomeiroModel.fromMap(e)).toList();
}

// Buscar Romeiro por ID
Future<RomeiroModel?> getRomeiroById({
  required RomeiroRepository repository,
  required int userId,
}) async {
  final res = await repository.getRomeiroById(userId);
  if (res != null) {
    return RomeiroModel.fromMap(res);
  }
  return null;
}
