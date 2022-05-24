import 'dart:convert';
import 'dart:developer';

import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;

import '../models/cidade.dart';
import '../models/estado.dart';
import '../database/database.dart';

class CidadeRepository extends Database {
  CidadeRepository({required super.connection});

  fetchByIdEstado(Estado estado) async {
    try {
      final response =
          await http.get(Uri.parse('$urlBase/${estado.id}/distritos'));

      if (response.statusCode == 200) {
        List<Cidade> cidades = jsonDecode(response.body)
            .map<Cidade>((cidade) => Cidade(
                  codigoEstado: estado.id,
                  nome: cidade['nome'],
                ))
            .toList();

        log('######### Salvando as cidades do estado ${estado.nome}');
        await saveAll(cidades);
      } else {
        throw Exception('Ocorreu um erro ao buscar as cidades na api do ibge');
      }
    } catch (e) {
      throw Exception('Ocorreu um erro: Causa: $e');
    }
  }

  fetch(List<Estado> estados) async {
    try {
      for (var estado in estados) {
        final response =
            await http.get(Uri.parse('$urlBase/${estado.id}/distritos'));

        if (response.statusCode == 200) {
          List<Cidade> cidades = jsonDecode(response.body)
              .map<Cidade>((cidade) => Cidade(
                    codigoEstado: estado.id,
                    nome: cidade['nome'],
                  ))
              .toList();

          log('######### Salvando as cidades do estado ${estado.nome}');
          await saveAll(cidades);
        } else {
          throw Exception(
              'Ocorreu um erro ao buscar as cidades na api do ibge');
        }
      }
    } catch (e) {
      throw Exception('Ocorreu um erro: Causa: $e');
    }
  }

  Future<void> saveAll(List<Cidade> cidades) async {
    try {
      for (var cidade in cidades) {
        log('***** Salvando cidade: ${cidade.nome}');
        await _save(cidade);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _save(Cidade cidade) async {
    try {
      await conn.transaction((_) async {
        await conn.query(
          'INSERT INTO cidade (id_uf, nome) VALUES(?,?)',
          [cidade.codigoEstado, cidade.nome],
        );
      });
    } on MySqlException catch (e) {
      print('Ocorreu um erro ao inserir as cidades. Causa: $e');
      throw Exception('Ocorreu um erro ao inserir uma cidades. Causa: $e');
    }
  }

  Future<List<Cidade>> findAll() async {
    try {
      var resultados = await conn.query('SELECT * FROM estado');
      return resultados
          .map<Cidade>((model) => Cidade.fromMap(model as Map<String, dynamic>))
          .toList();
    } on MySqlException catch (e) {
      print('Ocorreu um erro ao inserir os estados. Causa: $e');
      throw Exception('Ocorreu um erro ao inserir os estados. Causa: $e');
    }
  }

  Future<void> clean() async {
    try {
      await conn.transaction((_) async {
        await conn.query("DELETE FROM cidade WHERE 1 = 1");
      });
      log('######### Tabela de cidades Limpa');
    } on MySqlException catch (e) {
      print('Ocorreu um erro ao excluir as cidades. Causa: $e');
      throw Exception('Ocorreu um erro ao inserir as cidades. Causa: $e');
    }
  }
}
