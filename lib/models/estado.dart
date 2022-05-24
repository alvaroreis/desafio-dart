import 'dart:convert';

class Estado {
  int id;
  String sigla;
  String nome;
  Estado({
    required this.id,
    required this.sigla,
    required this.nome,
  });

  factory Estado.fromMap(Map<String, dynamic> source) {
    return Estado(
      id: source['id'] ?? 0,
      sigla: source['sigla'] ?? '',
      nome: source['nome'] ?? '',
    );
  }
  factory Estado.fromJson(String source) => Estado.fromMap(jsonDecode(source));

  Map<String, dynamic> toMap() {
    return {'id': id, 'sigla': sigla, 'nome': nome};
  }

  String toJson() => jsonEncode(toMap());

  @override
  String toString() => 'Estado(id: $id, sigla: $sigla, nome: $nome)';
}
