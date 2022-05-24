import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:mysql1/mysql1.dart';

import '../models/estado.dart';
import '../database/database.dart';

class EstadoRepository extends Database {
  EstadoRepository({required super.connection});

  Future<List<Estado>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(urlBase));

      if (200 == response.statusCode) {
        return jsonDecode(response.body)
            .map<Estado>((estado) => Estado.fromMap(estado))
            .toList();
      } else {
        throw Exception('Ocorreu um erro ao buscar os estados na api do ibge');
      }
    } catch (e) {
      throw Exception('Ocorreu um erro: Causa: $e');
    }
  }

  Future<void> saveAll(List<Estado> estados) async {
    try {
      for (var estado in estados) {
        log('***** Salvando estado: ${estado.nome}');
        await _save(estado);
      }
    } on Exception catch (e) {
      throw Exception(e);
    }
  }

  Future<void> _save(Estado estado) async {
    try {
      await conn.transaction((_) async {
        await conn.query(
          'INSERT INTO estado VALUES(?,?,?)',
          [estado.id, estado.sigla, estado.nome],
        );
      });
    } on MySqlException catch (e) {
      print('Ocorreu um erro ao inserir os estados. Causa: $e');
      throw Exception('Ocorreu um erro ao inserir os estados. Causa: $e');
    }
  }

  Future<Results> findAll() async {
    try {
      return await conn.query('SELECT * FROM estado');
    } on MySqlException catch (e) {
      print('Ocorreu um erro ao inserir os estados. Causa: $e');
      throw Exception('Ocorreu um erro ao inserir os estados. Causa: $e');
    }
  }

  Future<void> clean() async {
    try {
      await conn.transaction((_) async {
        await conn.query("DELETE FROM estado WHERE 1 = 1");
      });
      log('######### Tabela de Estados Limpa');
    } on MySqlException catch (e) {
      print('Ocorreu um erro ao excluir os estados. Causa: $e');
      throw Exception('Ocorreu um erro ao inserir os estados. Causa: $e');
    }
  }
}
