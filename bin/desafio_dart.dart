import 'dart:developer';

import 'package:desafio_dart/database/database.dart';
import 'package:desafio_dart/models/estado.dart';
import 'package:desafio_dart/repositories/cidade_repository.dart';
import 'package:desafio_dart/repositories/estado_repository.dart';

Future<void> main(List<String> args) async {
  log('######### Iniciando o processo');
  var _conn = await Database.openConnection();

  try {
    var cidadeRepository = CidadeRepository(connection: _conn);
    var estadoRepository = EstadoRepository(connection: _conn);

    log('######### limpando tabelas');
    await cidadeRepository.clean();
    await estadoRepository.clean();

    log('######### Buscando estados');
    List<Estado> estados = await estadoRepository.fetchAll();

    log('######### Salvando estados');
    await estadoRepository.saveAll(estados);

    // salvando as cidades do Pará - PA
    log('######### Buscando cidade do Pará');
    final pa = estados.where((estado) => estado.sigla == 'PA').first;
    await cidadeRepository.fetchByIdEstado(pa);

    //log('######### Buscando cidades por estados');
    // await cidadeRepository.fetch(estados);
  } catch (e) {
    log(e.toString());
  } finally {
    log('######### Finalizando processo');
    _conn.close();
  }
}
