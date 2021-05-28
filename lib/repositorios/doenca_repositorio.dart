import 'package:hope/repositorios/constante_repositorio.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:hope/modelos/doenca.dart';


class DoencaRepositorio {

  Future<Database> inicializarDatabase() async {
    Database db = await new DatabaseHelper().initializeDatabase();
    return db;
  }

  Future<int> inserirDoenca(Doenca doenca) async {
    Database db = await new DatabaseHelper().database;
    var result = await db.insert(ConstanteRepositorio.doencaTabela, doenca.toMap());
    return result;
  }

  Future<int> atualizarDoenca(Doenca doenca) async {
    var db = await new DatabaseHelper().database;
    var result = await db.update(ConstanteRepositorio.doencaTabela, doenca.toMap(),
        where: '${ConstanteRepositorio.doencaTabela_colId} = ?', whereArgs: [doenca.id]);
    return result;
  }

  Future<int> apagarDoenca(int id) async {
    var db = await new DatabaseHelper().database;
    int result = await db.rawDelete('DELETE FROM ${ConstanteRepositorio.doencaTabela} '
        'WHERE ${ConstanteRepositorio.doencaTabela_colId} = $id');
    return result;
  }

  Future<int> getTotalDoencas() async {
    Database db = await new DatabaseHelper().database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from ${ConstanteRepositorio.doencaTabela}');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Doenca>> getListaDoencas() async {
    var doencasMapList = await getDoencasMapList(); // Get 'Map List' from database
    int count = doencasMapList.length;         // Count the number of map entries in db table

    List<Doenca> listaDoencas = List<Doenca>();
    for (int i = 0; i < count; i++) {
      listaDoencas.add(Doenca.fromMapObject(doencasMapList[i]));
    }

    return listaDoencas;
  }

  Future<List<Map<String, dynamic>>> getDoencasMapList() async {
    Database db = await new DatabaseHelper().database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query(ConstanteRepositorio.doencaTabela,
        orderBy: '${ConstanteRepositorio.doencaTabela_colNome} ASC');
    return result;
  }

}