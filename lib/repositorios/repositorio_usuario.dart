import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/constante_repositorio.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class RepositorioUsuario {

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
            '${ConstanteRepositorio.usuarioTabela_colSenha} = ? AND '
            '${ConstanteRepositorio.usuarioTabela_colAtivo} = ?',
        whereArgs: [usuario.login, usuario.senha, 1]);
    int count = result.length;
    List<Usuario> listaUsuarios = <Usuario>[];
    for (int i = 0; i < count; i++) {
      listaUsuarios.add(Usuario.fromJson(result[i]));
    }

    if(listaUsuarios.isEmpty) return null;
    else return listaUsuarios[0];
  }

  Future<bool> existeUsuarioAtivoComLogin(Usuario usuario) async {
    var db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.usuarioTabela,
        where: '${ConstanteRepositorio.usuarioTabela_colLogin} = ? AND '
            '${ConstanteRepositorio.usuarioTabela_colAtivo} = ?',
        whereArgs: [usuario.login, 1]);
    int count = result.length;
    List<Usuario> listaUsuarios = <Usuario>[];
    for (int i = 0; i < count; i++) {
      listaUsuarios.add(Usuario.fromJson(result[i]));
    }
    bool resultado = listaUsuarios.isEmpty? false : true;
    return resultado;
  }

}