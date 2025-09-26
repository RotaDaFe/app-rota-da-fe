import 'package:rota_da_fe/repository/user_repository.dart';
import 'package:rota_da_fe/models/user.model.dart';

// Adicionar usuário
Future<int> addUser({
  required UserRepository repository,
  required nome,
  required posto,
  required senha,
  required servidor,
}) async {
  UserModel user = UserModel(
    nome: nome,
    posto: posto,
    senha: senha,
    servidor: servidor,
  );
  int res = await repository.addUser(user);
  return res;
}

// Atualizar usuário
Future<void> updateUser({
  required UserRepository repository,
  required id,
  required nome,
  required posto,
  required senha,
  String servidor = 'https://api-rotadafe.netlify.app/',
}) async {
  UserModel user = UserModel(
    nome: nome,
    posto: posto,
    senha: senha,
    servidor: servidor,
  );
  await repository.updateUser(id, user);
}

// Buscar todos os logins
Future<List> getAllLogin({required UserRepository repository}) async {
  List data = await repository.getAllUsers();
  return data;
}
