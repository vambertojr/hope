import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/constante_repositorio.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class QuizRepositorio {

  Future<Database> inicializarDatabase() async {
    Database db = await new DatabaseHelper().initializeDatabase();
    return db;
  }

  Future<int> inserirQuiz(Quiz quiz) async {
    Database db = await new DatabaseHelper().database;
    var result = await db.insert(ConstanteRepositorio.quizTabela, quiz.toJson());
    return result;
  }

  Future<int> atualizarQuiz(Quiz quiz) async {
    var db = await new DatabaseHelper().database;
    var result = await db.update(ConstanteRepositorio.quizTabela, quiz.toJson(),
        where: '${ConstanteRepositorio.quizTabela_colId} = ?', whereArgs: [quiz.id]);
    return result;
  }

  Future<int> apagarQuiz(int id) async {
    var db = await new DatabaseHelper().database;
    int result = await db.rawDelete('DELETE FROM ${ConstanteRepositorio.quizTabela} '
        'WHERE ${ConstanteRepositorio.quizTabela_colId} = $id');
    return result;
  }

  Future<int> getTotalQuiz() async {
    Database db = await new DatabaseHelper().database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from ${ConstanteRepositorio.quizTabela}');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Quiz>> getListaQuiz() async {
    var quizMapList = await getQuizMapList();
    int count = quizMapList.length;

    List<Quiz> listaQuiz = List<Quiz>();
    for (int i = 0; i < count; i++) {
      listaQuiz.add(Quiz.fromJson(quizMapList[i]));
    }

    return listaQuiz;
  }

  Future<List<Map<String, dynamic>>> getQuizMapList() async {
    Database db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.quizTabela,
        orderBy: '${ConstanteRepositorio.quizTabela_colId} ASC');
    return result;
  }

  Future<List<Quiz>> getListaQuizByUser() async {
    List<Quiz> listaQuiz = <Quiz>[];
    var quizMapList = await getQuizMapListByUser();
    int count = quizMapList.length;
    for (int i = 0; i < count; i++) {
      listaQuiz.add(Quiz.fromJson(quizMapList[i]));
    }
    return listaQuiz;
  }

  Future<List<Map<String, dynamic>>> getQuizMapListByUser() async {
    Usuario usuario = await Login.getUsuarioLogado();
    if(usuario == null){
      print("usuario null em getQuizMapListByUser()");
      return [];
    }
    Database db = await new DatabaseHelper().database;
    var result = await db.query(ConstanteRepositorio.quizTabela,
        where: '${ConstanteRepositorio.quizTabela_colUsuario} = ? ',
        whereArgs: [usuario.id],
        orderBy: '${ConstanteRepositorio.quizTabela_colId} DESC');
    return result;
  }

}