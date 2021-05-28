import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/constante_repositorio.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class PerguntaRepositorio {

  Future<Database> inicializarDatabase() async {
    Database db = await new DatabaseHelper().initializeDatabase();
    return db;
  }

  Future<int> inserirPergunta(Pergunta pergunta) async {
    Database db = await new DatabaseHelper().database;
    var result = await db.insert(ConstanteRepositorio.perguntaTabela, pergunta.toMap());
    return result;
  }

  Future<int> atualizarPergunta(Pergunta pergunta) async {
    var db = await new DatabaseHelper().database;
    var result = await db.update(ConstanteRepositorio.perguntaTabela, pergunta.toMap(),
        where: '${ConstanteRepositorio.perguntaTabela_colId} = ?', whereArgs: [pergunta.id]);
    return result;
  }

  Future<int> apagarPergunta(int id) async {
    var db = await new DatabaseHelper().database;
    int result = await db.rawDelete('DELETE FROM ${ConstanteRepositorio.perguntaTabela} '
        'WHERE ${ConstanteRepositorio.perguntaTabela_colId} = $id');
    return result;
  }

  Future<int> getTotalPerguntas() async {
    Database db = await new DatabaseHelper().database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from ${ConstanteRepositorio.perguntaTabela}');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Pergunta>> getListaPerguntas() async {
    var perguntasMapList = await getPerguntasMapList(); // Get 'Map List' from database
    int count = perguntasMapList.length;         // Count the number of map entries in db table

    List<Pergunta> listaPerguntas = List<Pergunta>();
    for (int i = 0; i < count; i++) {
      listaPerguntas.add(Pergunta.fromMapObject(perguntasMapList[i]));
    }

    return listaPerguntas;
  }

  Future<List<Map<String, dynamic>>> getPerguntasMapList() async {
    Database db = await new DatabaseHelper().database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query(ConstanteRepositorio.perguntaTabela,
        orderBy: '${ConstanteRepositorio.perguntaTabela_colTexto} ASC');
    return result;
  }
}