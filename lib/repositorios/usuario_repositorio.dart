import 'package:flutter/cupertino.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/constante_repositorio.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioRepositorio {

  Future<Database> inicializarDatabase() async {
    Database db = await new DatabaseHelper().initializeDatabase();
    return db;
  }

  Future<int> inserirUsuario(Usuario usuario) async {
    Database db = await new DatabaseHelper().database;
    var result = await db.insert(ConstanteRepositorio.usuarioTabela, usuario.toJson());
    return result;
  }

  Future<int> atualizarUsuario(Usuario usuario) async {
    var db = await new DatabaseHelper().database;
    var result = await db.update(ConstanteRepositorio.usuarioTabela, usuario.toJson(),
        where: '${ConstanteRepositorio.usuarioTabela_colId} = ?', whereArgs: [usuario.id]);
    return result;
  }

  Future<int> apagarUsuario(int id) async {
    var db = await new DatabaseHelper().database;
    int result = await db.rawDelete('DELETE FROM ${ConstanteRepositorio.usuarioTabela} '
        'WHERE ${ConstanteRepositorio.usuarioTabela_colId} = $id');
    return result;
  }

  Future<Usuario> getUsuario(Usuario usuario) async {
    var db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.usuarioTabela,
        where: '${ConstanteRepositorio.usuarioTabela_colLogin} = ? AND '
            '${ConstanteRepositorio.usuarioTabela_colSenha} = ?',
        whereArgs: [usuario.login, usuario.senha]);
    int count = result.length;
    List<Usuario> listaUsuarios = List<Usuario>();
    for (int i = 0; i < count; i++) {
      print(Usuario.fromJson(result[i]));
      listaUsuarios.add(Usuario.fromJson(result[i]));
    }

    if(listaUsuarios.isEmpty) return null;
    else return listaUsuarios[0];
  }

  Future<int> getTotalUsuarios() async {
    Database db = await new DatabaseHelper().database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from ${ConstanteRepositorio.usuarioTabela}');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Usuario>> getListaUsuarios() async {
    var usuariosMapList = await getUsuariosMapList();
    int count = usuariosMapList.length;

    List<Usuario> listaUsuarios = List<Usuario>();
    for (int i = 0; i < count; i++) {
      listaUsuarios.add(Usuario.fromJson(usuariosMapList[i]));
    }

    return listaUsuarios;
  }

  Future<List<Map<String, dynamic>>> getUsuariosMapList() async {
    Database db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.usuarioTabela,
        orderBy: '${ConstanteRepositorio.usuarioTabela_colLogin} ASC');
    return result;
  }

}