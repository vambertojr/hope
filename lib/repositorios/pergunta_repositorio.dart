import 'package:hope/modelos/doenca.dart';
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
    var result = await db.insert(ConstanteRepositorio.perguntaTabela, pergunta.toJson());
    return result;
  }

  Future<int> atualizarPergunta(Pergunta pergunta) async {
    var db = await new DatabaseHelper().database;
    var result = await db.update(ConstanteRepositorio.perguntaTabela, pergunta.toJson(),
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
    var perguntasMapList = await getPerguntasMapList();
    int count = perguntasMapList.length;

    List<Pergunta> listaPerguntas = <Pergunta>[];
    for (int i = 0; i < count; i++) {
      listaPerguntas.add(Pergunta.fromJson(perguntasMapList[i]));
    }

    return listaPerguntas;
  }

  Future<List<Map<String, dynamic>>> getPerguntasMapList() async {
    Database db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.perguntaTabela,
        orderBy: '${ConstanteRepositorio.perguntaTabela_colId} ASC');
    return result;
  }

  //Deve ser usado no lugar de último método da classe, que não funciona
  Future<List<Pergunta>> getListaPerguntasPorDoenca(Doenca doenca) async {
    List<Pergunta> perguntasSelecionadas = [];
    var todasPerguntas = await getListaPerguntas();
    for(int i=0; i<todasPerguntas.length; i++){
      if(todasPerguntas[i].doenca == doenca){
        perguntasSelecionadas.add(todasPerguntas[i]);
      }
    }
    return perguntasSelecionadas;
  }

  /*INVESTIGAR
  //A busca não funciona para filtrar por ID da doença, apenas por ID da pergunta
  Future<List<Map<String, dynamic>>> _getPerguntasMapListPorDoenca(Doenca doenca) async {
    Database db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.perguntaTabela,
        where: '${ConstanteRepositorio.perguntaTabela_colDoenca} = ? ',
        whereArgs: [doenca.id],
        orderBy: '${ConstanteRepositorio.perguntaTabela_colId} ASC');
    return result;
  }

  //Método não funciona porque o auxiliar não consegue filtra por doença. Investigar depois.
  Future<List<Pergunta>> getListaPerguntasPorDoenca(Doenca doenca) async {
    var perguntasMapList = await _getPerguntasMapListPorDoenca(doenca);
    int count = perguntasMapList.length;

    List<Pergunta> listaPerguntas = <Pergunta>[];
    for (int i = 0; i < count; i++) {
      listaPerguntas.add(Pergunta.fromJson(perguntasMapList[i]));
    }

    return listaPerguntas;
  }*/


}