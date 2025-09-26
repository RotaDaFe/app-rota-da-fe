

class RomeiroModel {
  String uuid;
  String nome;
  int idade;
  String cidade;
  String localDeAtendimento;
  String sexo;
  String patologia;
  bool atualizado;
  String? createdAt; // Campo opcional
  String? updatedAt; // Campo opcional

  // Construtor da classe RomeiroModel
  RomeiroModel({
    required this.uuid,
    required this.nome,
    required this.idade,
    required this.cidade,
    required this.localDeAtendimento,
    required this.sexo,
    required this.patologia,
    this.atualizado = false,
    this.createdAt, // Opcional
    this.updatedAt, // Opcional
  });

  // Método que cria um objeto RomeiroModel a partir de um Map
  factory RomeiroModel.fromMap(Map<String, dynamic> map) {
    return RomeiroModel(
      uuid: map['uuid'] ?? '',
      nome: map['nome'] ?? '',
      idade: map['idade'] ?? 0,
      cidade: map['cidade'] ?? '',
      localDeAtendimento: map['localDeAtendimento'] ?? '',
      sexo: map['sexo'] ?? '',
      patologia: map['patologia'] ?? '',
      atualizado: map['atualizado'] ?? false,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
    );
  }

  // Método que converte um objeto RomeiroModel em um Map
  Map<String, dynamic> toMap() {
    final map = {
      'uuid': uuid,
      'nome': nome,
      'idade': idade,
      'cidade': cidade,
      'localDeAtendimento': localDeAtendimento,
      'sexo': sexo,
      'patologia': patologia,
      'atualizado': atualizado,
    };
    if (createdAt != null) {
      map['createdAt'] = createdAt as dynamic;
    }
    if (updatedAt != null) {
      map['updatedAt'] = updatedAt as dynamic;
    }
    return map;
  }
}
