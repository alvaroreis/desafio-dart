import 'dart:convert';

class Cidade {
  int? id;
  int codigoEstado;
  String nome;
  Cidade({
    this.id,
    required this.codigoEstado,
    required this.nome,
  });

  factory Cidade.fromMap(Map<String, dynamic> source) {
    return Cidade(
      codigoEstado: source['id_uf'],
      nome: source['nome'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'id_uf': codigoEstado, 'nome': nome};
  }

  factory Cidade.fromJson(String source) => Cidade.fromMap(jsonDecode(source));
  String toJson() => jsonEncode(toMap());

  @override
  String toString() =>
      'Cidade(id: $id, codigoEstado: $codigoEstado, nome: $nome)';
}
