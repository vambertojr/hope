import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/resposta.dart';
import 'package:hope/repositorios/doenca_repositorio.dart';
import 'package:hope/repositorios/pergunta_repositorio.dart';
import 'package:hope/repositorios/quiz_repositorio.dart';
import 'package:hope/visoes/responder_quiz.dart';


class QuizInfo extends StatefulWidget {

  final String appBarTitle;
  final Quiz quiz;

  QuizInfo(this.quiz, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return QuizInfoState(this.quiz, this.appBarTitle);
  }
}

class QuizInfoState extends State<QuizInfo> {

  PerguntaRepositorio _perguntasRepositorio;
  DoencaRepositorio _doencasRepositorio;
  QuizRepositorio _quizRepositorio;

  String _appBarTitle;
  Quiz _quiz;

  List<Doenca> _doencasLista;
  Doenca _doencaSelecionada;
  List<DropdownMenuItem<Doenca>> _menuDoencas;

  TextEditingController _quantidadePerguntasController;
  TextEditingController _tituloController;

  QuizInfoState(this._quiz, this._appBarTitle);

  @override
  void initState() {
    super.initState();
    _perguntasRepositorio = PerguntaRepositorio();
    _doencasRepositorio = DoencaRepositorio();
    _quizRepositorio = QuizRepositorio();
    _quantidadePerguntasController = new TextEditingController(text: _quiz.totalPerguntas.toString());
    _tituloController = new TextEditingController(text: _quiz.titulo);
    _inicializarMenuDoencas();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(

        onWillPop: () {
          return _voltarParaUltimaTela();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(_appBarTitle),
            backgroundColor: Colors.teal,
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  _voltarParaUltimaTela();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _tituloController,
                    style: textStyle,
                    onChanged: (value) {
                      _atualizarTitulo();
                    },
                    decoration: InputDecoration(
                        labelText: 'Título',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: DropdownButtonFormField<Doenca>(
                    value: _doencaSelecionada,
                    onChanged: (doenca) {
                      setState(() {
                        _atualizarDoenca(doenca);
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Doença',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    items: _menuDoencas,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _quantidadePerguntasController,
                    style: textStyle,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _atualizarQuantidadePerguntas();
                    },
                    decoration: InputDecoration(
                        labelText: 'Número de perguntas',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: Text(
                            'Criar',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                              setState(() {
                              _criarQuiz();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                    ],
                  ),
                ),

              ],
            ),
          ),

        ));
  }

  void _atualizarDoencasLista(){
    _menuDoencas = _doencasLista.map((doenca) => DropdownMenuItem<Doenca>(
      child: Text(doenca.nome),
      value: doenca,
    )
    ).toList();
  }

  void _inicializarMenuDoencas() async {
      this._doencasLista = [new Doenca('Nenhuma doença específica', '', '')];
      Future<List<Doenca>> listaDoencasFutura = _doencasRepositorio.getListaDoencas();
      listaDoencasFutura.then((listaDoencas) {
        setState(() {
          this._doencasLista += listaDoencas;
          _atualizarDoencasLista();
          _inicializarDoencaSelecionada();
        });
      });
  }

  void _inicializarDoencaSelecionada(){
    if(_quiz.doenca == null || _quiz.doenca.nome.isEmpty){
      _quiz.doenca = this._doencasLista[0];
    }
    this._doencaSelecionada = _quiz.doenca;
  }

  void _atualizarTitulo() {
    _quiz.titulo = this._tituloController.text;
  }

  void _atualizarDoenca(Doenca doenca){
    _doencaSelecionada = doenca;
    _quiz.doenca = _doencaSelecionada;
  }

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  void _atualizarQuantidadePerguntas() {
   _quiz.totalPerguntas = int.parse(this._quantidadePerguntasController.text);
  }

  void _criarQuiz() async {
    _voltarParaUltimaTela();

    int result;
    if (_quiz.id != null) {
      result = await _quizRepositorio.atualizarQuiz(_quiz);
      if (result != 0) {
        _showAlertDialog('Status', 'Quiz atualizado com sucesso');
      } else {
        _showAlertDialog('Status', 'Erro ao atualizar quiz');
      }
    } else {
      await _sortearPerguntas();
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        String mensagem = '${_quiz.titulo} (${_quiz.totalPerguntas} perguntas)';
        if(_quiz.totalPerguntas==1) mensagem = '${_quiz.titulo} (${_quiz.totalPerguntas} pergunta)';
        return ResponderQuiz(_quiz, mensagem);
      }));
    }
  }

  List _shuffle(List itens) {
    Random random = new Random();
    for (int i=itens.length-1; i>0; i--) {
      int n = random.nextInt(i+1);
      int temp = itens[i];
      itens[i] = itens[n];
      itens[n] = temp;
    }
    return itens;
  }

  List<Resposta> _converterParaListaRespostas(List perguntas){
    List<Resposta> respostas = [];
    for (int i=0; i<perguntas.length; i++) {
      respostas.add(new Resposta(0, perguntas[i]));
    }
    return respostas;
  }

  _sortearPerguntas() async {
    List<Pergunta> todasAsPerguntas;
    if(_quiz.doenca.id != null){
      todasAsPerguntas = await _perguntasRepositorio.getListaPerguntasPorDoenca(_quiz.doenca);
    } else {
      todasAsPerguntas = await _perguntasRepositorio.getListaPerguntas();
    }

    print("Total de perguntas: ${todasAsPerguntas.length}");

    if(todasAsPerguntas==null || todasAsPerguntas.isEmpty){
      _showAlertDialog('Status', 'Não é possível gerar quiz porque não há perguntas cadastradas.');
      return;
    } else if(todasAsPerguntas.length<_quiz.totalPerguntas){
      _showAlertDialog('Status', 'Não há perguntas cadastradas suficientes. O quiz será gerado com as perguntas existentes.');
      _quiz.perguntas = _converterParaListaRespostas(_shuffle(todasAsPerguntas));
      _quiz.totalPerguntas = _quiz.perguntas.length;
    } else if(todasAsPerguntas.length==_quiz.totalPerguntas){
      _quiz.perguntas = _converterParaListaRespostas(_shuffle(todasAsPerguntas));
    } else {
      Random random = new Random();
      _quiz.perguntas = [];
      while(_quiz.perguntas.length<_quiz.totalPerguntas){
        int indice = random.nextInt(todasAsPerguntas.length);
        Pergunta pergunta = todasAsPerguntas[indice];
        if(!_quiz.perguntas.contains(pergunta)){
          _quiz.perguntas.add(new Resposta(0, pergunta));
        }
      }
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: Colors.white,
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}