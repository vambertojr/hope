import 'package:hope/repositorios/constante_repositorio.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:hope/modelos/doenca.dart';


class RepositorioDoenca {

  Future<int> inserirDoenca(Doenca doenca) async {
    Database db = await new DatabaseHelper().database;
    var result = await db.insert(ConstanteRepositorio.doencaTabela, doenca.toJson());
    return result;
  }

  Future<int> atualizarDoenca(Doenca doenca) async {
    var db = await new DatabaseHelper().database;
    var result = await db.update(ConstanteRepositorio.doencaTabela, doenca.toJson(),
        where: '${ConstanteRepositorio.doencaTabela_colId} = ?', whereArgs: [doenca.id]);
    return result;
  }

  Future<int> apagarDoenca(int id) async {
    var db = await new DatabaseHelper().database;
    int result = await db.rawDelete('DELETE FROM ${ConstanteRepositorio.doencaTabela} '
        'WHERE ${ConstanteRepositorio.doencaTabela_colId} = $id');
    return result;
  }

  Future<List<Doenca>> getListaDoencasAtivas() async {
    var doencasMapList = await _getDoencasAtivasMapList();
    int count = doencasMapList.length;

    List<Doenca> listaDoencas = <Doenca>[];
    for (int i = 0; i < count; i++) {
      listaDoencas.add(Doenca.fromJson(doencasMapList[i]));
    }

    return listaDoencas;
  }

  Future<List<Map<String, dynamic>>> _getDoencasAtivasMapList() async {
    Database db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.doencaTabela,
        where: '${ConstanteRepositorio.doencaTabela_colAtiva} = ?',
        whereArgs: [1],
        orderBy: '${ConstanteRepositorio.doencaTabela_colNome} ASC');
    return result;
  }

  Future<bool> existeDoencaAtivaComMesmoNome(Doenca doenca) async {
    var db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.doencaTabela,
        where: '${ConstanteRepositorio.doencaTabela_colNome} = ? AND '
            '${ConstanteRepositorio.doencaTabela_colAtiva} = ?',
        whereArgs: [doenca.nome, 1]);
    int count = result.length;
    List<Doenca> listaDoencas = <Doenca>[];
    for (int i = 0; i < count; i++) {
      Doenca d = Doenca.fromJson(result[i]);
      if(doenca.id == null || (doenca.id!=d.id)) listaDoencas.add(d);
    }
    bool resultado = listaDoencas.isEmpty? false : true;
    return resultado;
  }

}