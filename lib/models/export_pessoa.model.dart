import 'romeiro.model.dart';

class ExportPessoaModel {
  ExportPessoaModel copyWith({
    String? operador_nome,
    String? operador_email,
  }) {
    return ExportPessoaModel(
      uuid: this.uuid,
      nome: this.nome,
      idade: this.idade,
      cidade: this.cidade,
      sexo: this.sexo,
      localatendimento: this.localatendimento,
      condicaofisica: this.condicaofisica,
      operador_nome: operador_nome ?? this.operador_nome,
      operador_email: operador_email ?? this.operador_email,
      datatime: this.datatime,
    );
  }
  // Construtor auxiliar para converter RomeiroModel em ExportPessoaModel
  factory ExportPessoaModel.fromRomeiroModel(RomeiroModel r) {
    return ExportPessoaModel(
      uuid: r.uuid,
      nome: r.nome,
      idade: r.idade,
      cidade: r.cidade,
      sexo: r.sexo,
      localatendimento: r.localDeAtendimento,
      condicaofisica: r.patologia,
      operador_nome: '', // Preencher se necessário
      operador_email: '', // Preencher se necessário
      datatime: r.createdAt ?? DateTime.now().toUtc().toIso8601String(),
    );
  }
  final String uuid;
  final String nome;
  final int idade;
  final String cidade;
  final String sexo;
  final String localatendimento;
  final String condicaofisica;
  final String operador_nome;
  final String operador_email;
  final String datatime;

  ExportPessoaModel({
    required this.uuid,
    required this.nome,
    required this.idade,
    required this.cidade,
    required this.sexo,
    required this.localatendimento,
    required this.condicaofisica,
    required this.operador_nome,
    required this.operador_email,
    required this.datatime,
  });

  factory ExportPessoaModel.fromMap(Map<String, dynamic> map) {
    return ExportPessoaModel(
      uuid: map['uuid'] ?? '',
      nome: map['nome'] ?? '',
      idade: map['idade'] ?? 0,
      cidade: map['cidade'] ?? '',
      sexo: map['sexo'] ?? '',
      localatendimento: map['localatendimento'] ?? map['localDeAtendimento'] ?? '',
      condicaofisica: map['condicaofisica'] ?? map['patologia'] ?? '',
      operador_nome: map['operador_nome'] ?? '',
      operador_email: map['operador_email'] ?? '',
      datatime: map['datatime'] ?? map['createdAt'] ?? DateTime.now().toUtc().toIso8601String(),
    );
  }

  String _formatDate(String dateStr) {
    try {
      DateTime dt = DateTime.parse(dateStr);
      // Retorna no formato yyyy-MM-dd HH:mm:ss
      return '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }

  Map<String, dynamic> toJson() {
    // Normalizar sexo
    String sexoNormalizado = sexo.toLowerCase();
    if (sexoNormalizado == 'feminino') sexoNormalizado = 'feminino';
    else if (sexoNormalizado == 'masculino') sexoNormalizado = 'masculino';
    else if (sexoNormalizado == 'outros' || sexoNormalizado == 'outro') sexoNormalizado = 'outros';
    else sexoNormalizado = 'outros';

    // Garantir operador_email válido
    String emailValido = operador_email.contains('@') && operador_email.contains('.')
      ? operador_email
      : 'no-reply@rotadafe.com';

    // Formatar datatime
    String datatimeFormatado = datatime.isNotEmpty ? _formatDate(datatime) : _formatDate(DateTime.now().toUtc().toIso8601String());

    return {
      'uuid': uuid.isNotEmpty ? uuid : '',
      'nome': nome.isNotEmpty ? nome : '',
      'idade': idade,
      'cidade': cidade.isNotEmpty ? cidade : '',
      'sexo': sexoNormalizado,
      'localatendimento': localatendimento.isNotEmpty ? localatendimento : '',
      'condicaofisica': condicaofisica.isNotEmpty ? condicaofisica : '',
      'operador_nome': operador_nome.isNotEmpty ? operador_nome : '',
      'operador_email': emailValido,
      'datatime': datatimeFormatado,
    };
  }
}
