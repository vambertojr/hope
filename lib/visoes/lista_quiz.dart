import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';
import 'package:hope/visoes/homepage.dart';
import 'package:hope/visoes/quiz_concluido.dart';
import 'package:hope/visoes/quiz_info.dart';
import 'package:intl/intl.dart';

class ListaQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaQuizState();
  }
}

class ListaQuizState extends State<ListaQuiz> {

  RepositorioQuiz _databaseHelper;
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

    _databaseHelper = RepositorioQuiz();

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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: _getListaQuizView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _navigateToDetail(Quiz('', _usuario, null, 10, [], 0));
        },
        tooltip: 'Criar quiz',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _configurarSubtitle(Quiz quiz){
    String subtitle;
    if(quiz.doenca!=null && quiz.doenca.nome.isNotEmpty){
      subtitle = quiz.doenca.nome;
    } else {
      subtitle = 'Nenhuma doença específica';
    }
    subtitle += ' (${DateFormat('dd/MM/yyyy').format(quiz.data)})';
    return subtitle;
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
            subtitle: Text(_configurarSubtitle(this._listaQuiz[position])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _dialogoConfirmacaoExclusaoQuiz(context, _listaQuiz[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              _navegarParaRespostas(this._listaQuiz[position]);
            },
          ),
        );
      },
    );
  }

  _getFirstLetter(String title) {
    if(title.length>2) return title.substring(0, 2);
    else return title.substring(0, 1);
  }

  void _dialogoConfirmacaoExclusaoQuiz(BuildContext contexto, Quiz quiz){
    Widget botaoCancelar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(contexto).pop();
      },
    );

    Widget botaoContinuar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Continuar"),
      onPressed:  () {
        _apagar(contexto, quiz);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('Confirmação'),
      content: Text('Você tem certeza que deseja apagar o quiz?'),
      actions: [
        botaoCancelar,
        botaoContinuar,
      ],
    );

    showDialog(
      context: contexto,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _apagar(BuildContext context, Quiz quiz) async {
    int resultado = await _databaseHelper.apagarQuiz(quiz.id);

    _voltarParaUltimaTela();

    if (resultado != 0) {
      _showSnackBar(context, 'Quiz apagado com sucesso');
      _atualizarListaQuiz();
    } else {
      _showSnackBar(context, 'Erro ao apagar quiz');
    }
  }

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  _navegarParaRespostas(Quiz quiz) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return QuizConcluido(quiz, quiz.titulo);
    }));
  }

  _atualizarListaQuiz() async {
    Future<List<Quiz>> listaQuizFutura = _databaseHelper.getListaQuizByUser();
    listaQuizFutura.then((listaQuiz) {
      setState(() {
        this._listaQuiz = listaQuiz;
        this._totalQuiz = listaQuiz.length;
      });
    });
  }

  void _logout(context) async {
    Login.registrarLogout();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }


}