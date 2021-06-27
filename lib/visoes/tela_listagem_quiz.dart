import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/controladores/login_controller.dart';
import 'package:hope/controladores/quiz_controller.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';
import 'package:hope/visoes/componentes/dialogo_confirmacao_exclusao.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';
import 'package:hope/visoes/tela_quiz_concluido.dart';
import 'package:hope/visoes/tela_cadastro_quiz.dart';
import 'package:intl/intl.dart';

class TelaListagemQuiz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaListagemQuizState();
  }
}

class TelaListagemQuizState extends State<TelaListagemQuiz> {

  ComponentesUtil _gerenciadorComponentes;
  RepositorioQuiz _repositorioQuiz;
  List<Quiz> _listaQuiz;
  int _totalQuiz;
  Usuario _usuario;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    Future<Usuario> usuariof = LoginController.getUsuarioLogado();
    usuariof.then((value) {
      setState(() {
        _usuario = value;
      });
    });

    _repositorioQuiz = RepositorioQuiz();

    if (_listaQuiz == null) {
      _listaQuiz = [];
      _totalQuiz = 0;
      _atualizarListaQuiz();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _gerenciadorComponentes.appBar("Quiz", context),
      body: _getListaQuizView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _navegarParaCadastroQuiz(Quiz('', _usuario, null, 10, [], 0));
        },
        tooltip: 'Criar quiz',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _configurarLegenda(Quiz quiz){
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
              child: Text(_gerenciadorComponentes.getPrimeirasLetras(this._listaQuiz[position].data.toString()),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this._listaQuiz[position].titulo,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(_configurarLegenda(this._listaQuiz[position])),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    String mensagem = 'Você tem certeza que deseja apagar o quiz?';
                    DialogoConfirmacaoExclusao.showObject(context, mensagem: mensagem, apagar: _apagar,
                        argumento: _listaQuiz[position]);
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

  void _apagar(Object object) async {
    Quiz quiz = object;
    QuizController quizController = QuizController(quiz);
    int resultado = await quizController.apagar();

    Navigator.pop(context, true);

    if (resultado != 0) {
      _exibirSnackBar('Quiz apagado com sucesso');
      _atualizarListaQuiz();
    } else {
      _exibirSnackBar('Erro ao apagar quiz');
    }
  }

  void _exibirSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navegarParaCadastroQuiz(Quiz quiz) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      if(quiz.titulo == null || quiz.titulo.isEmpty) {
        return TelaCadastroQuiz(quiz, 'Criar quiz');
      } else return TelaCadastroQuiz(quiz, quiz.titulo);
    }));

    if (result == true) {
      await _atualizarListaQuiz();
    }
  }

  _navegarParaRespostas(Quiz quiz) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TelaQuizConcluido(quiz, quiz.titulo);
    }));
  }

  _atualizarListaQuiz() async {
    Future<List<Quiz>> listaQuizFutura = _repositorioQuiz.getListaQuizByUser();
    listaQuizFutura.then((listaQuiz) {
      setState(() {
        this._listaQuiz = listaQuiz;
        this._totalQuiz = listaQuiz.length;
      });
    });
  }

}