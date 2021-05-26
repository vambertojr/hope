import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hope/doenca.dart'
 show Doenca;

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String doencaTabela = 'tabela_doencas';
  String colId = 'id';
  String colNome = 'nome';
  String colDescricao = 'descricao';
  String colAgente = 'agente';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'doencas.db';

    // Open/create the database at a given path
    var doencasDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return doencasDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $doencaTabela($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colNome TEXT, '
        '$colDescricao TEXT, $colAgente TEXT)');
  }

  Future<List<Map<String, dynamic>>> getDoencasMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query(doencaTabela, orderBy: '$colNome ASC');
    return result;
  }

  Future<int> inserirDoenca(Doenca doenca) async {
    Database db = await this.database;
    var result = await db.insert(doencaTabela, doenca.toMap());
    return result;
  }

  Future<int> updateDoenca(Doenca doenca) async {
    var db = await this.database;
    var result = await db.update(doencaTabela, doenca.toMap(), where: '$colId = ?', whereArgs: [doenca.id]);
    return result;
  }

  Future<int> deleteDoenca(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $doencaTabela WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $doencaTabela');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Doenca>> getListaDoencas() async {

    var doencasMapList = await getDoencasMapList(); // Get 'Map List' from database
    int count = doencasMapList.length;         // Count the number of map entries in db table

    List<Doenca> listaDoencas = List<Doenca>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      listaDoencas.add(Doenca.fromMapObject(doencasMapList[i]));
    }

    return listaDoencas;
  }

}