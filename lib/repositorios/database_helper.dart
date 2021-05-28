import 'package:hope/repositorios/constante_repositorio.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  // Named constructor to create instance of DatabaseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
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
    String path = directory.path + 'hope.db';

    // Open/create the database at a given path
    var hopeDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return hopeDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE ${ConstanteRepositorio.doencaTabela}('
        '${ConstanteRepositorio.doencaTabela_colId} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${ConstanteRepositorio.doencaTabela_colNome} TEXT, '
        '${ConstanteRepositorio.doencaTabela_colDescricao} TEXT, '
        '${ConstanteRepositorio.doencaTabela_colAgente} TEXT)'
    );

    await db.execute(
        'CREATE TABLE ${ConstanteRepositorio.perguntaTabela}('
        '${ConstanteRepositorio.perguntaTabela_colId} INTEGER PRIMARY KEY AUTOINCREMENT, '
        '${ConstanteRepositorio.perguntaTabela_colTexto} TEXT, '
        '${ConstanteRepositorio.perguntaTabela_colDoenca} INTEGER, '
        '${ConstanteRepositorio.perguntaTabela_colAlternativa1} TEXT, '
        '${ConstanteRepositorio.perguntaTabela_colAlternativa2} TEXT, '
        '${ConstanteRepositorio.perguntaTabela_colAlternativa3} TEXT, '
        '${ConstanteRepositorio.perguntaTabela_colAlternativa4} TEXT, '
        '${ConstanteRepositorio.perguntaTabela_colAlternativa5} TEXT, '
        '${ConstanteRepositorio.perguntaTabela_colGabarito} INTEGER, '
        'FOREIGN KEY(${ConstanteRepositorio.perguntaTabela_colDoenca}) REFERENCES '
        '${ConstanteRepositorio.doencaTabela}(${ConstanteRepositorio.doencaTabela_colId}))'
    );
  }

}