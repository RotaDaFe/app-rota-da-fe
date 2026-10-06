import 'package:rota_da_fe/config/api_config.dart';

class UserModel {
  String nome;
  String posto;
  String senha;
  String servidor;

  // Construtor da classe
  UserModel({
    required this.nome,
    required this.posto,
    required this.senha,
    required this.servidor,
  });

  // Método que cria um objeto User a partir de um Map
  factory UserModel.fromMap(Map<String, String> map) {
    return UserModel(
      nome: map['nome'] ?? '',
      posto: map['posto'] ?? '',
      senha: map['senha'] ?? '',
      servidor: ApiConfig.normalizeBaseUrl(map['servidor']),
    );
  }

  // Método que converte o objeto User em um Map
  Map<String, String> toMap() {
    return {'nome': nome, 'posto': posto, 'senha': senha, 'servidor': servidor};
  }
}
