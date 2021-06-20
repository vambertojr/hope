import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/quiz_repositorio.dart';
import 'package:hope/visoes/quiz_info.dart';
import 'package:sqflite/sqflite.dart';

class ListaQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaQuizState();
  }
}

class ListaQuizState extends State<ListaQuiz> {

  QuizRepositorio _databaseHelper;
  List<Quiz> _listaQuiz;
  int _totalQuiz;
  Usuario _usuario;

  @override
  void initState() {
    super.initState();
    Future<Usuario> usuariof = Login.getUsuarioLogado();
    usuariof.then((value) {
      setState(() {
        _usuario = value;
      });
    });

    _databaseHelper = QuizRepositorio();

    if (_listaQuiz == null) {
      _listaQuiz = [];
      _totalQuiz = 0;
      _atualizarListaQuiz();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"),
        backgroundColor: Colors.teal,
      ),
      body: _getListaQuizView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _navigateToDetail(Quiz('', _usuario, null, 10, null, 0));
        },
        tooltip: 'Criar quiz',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _configurarNomeDoenca(Quiz quiz){
    String nome;
    if(quiz.doenca!=null && quiz.doenca.nome.isNotEmpty){
      nome = quiz.doenca.nome;
    } else {
      nome = 'Nenhuma doença específica';
    }
    return nome;
  }

  ListView _getListaQuizView() {
    return ListView.builder(
      itemCount: _totalQuiz,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(_getFirstLetter(this._listaQuiz[position].data.toString()),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this._listaQuiz[position].titulo,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_configurarNomeDoenca(this._listaQuiz[position])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, _listaQuiz[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              _navigateToDetail(this._listaQuiz[position]);
              Colors.teal;
            },
          ),
        );
      },
    );
  }

  _getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Quiz quiz) async {
    int result = await _databaseHelper.apagarQuiz(quiz.id);
    if (result != 0) {
      _showSnackBar(context, 'Quiz apagado com sucesso');
      _atualizarListaQuiz();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _navigateToDetail(Quiz quiz) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      if(quiz.titulo == null || quiz.titulo.isEmpty) {
        return QuizInfo(quiz, 'Criar quiz');
      } else return QuizInfo(quiz, quiz.titulo);
    }));

    if (result == true) {
      await _atualizarListaQuiz();
    }
  }

  void _atualizarListaQuiz() async {
    Future<List<Quiz>> listaQuizFutura = _databaseHelper.getListaQuizByUser();
    listaQuizFutura.then((listaQuiz) {
      setState(() {
        this._listaQuiz = listaQuiz;
        this._totalQuiz = listaQuiz.length;
      });
    });
  }


}