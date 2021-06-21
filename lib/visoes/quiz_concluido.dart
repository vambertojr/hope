import 'package:flutter/material.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/visoes/homepage.dart';


class QuizConcluido extends StatefulWidget {

  final String appBarTitle;
  final Quiz quiz;

  QuizConcluido(this.quiz, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return QuizConcluidoState(this.quiz, this.appBarTitle);
  }
}

class QuizConcluidoState extends State<QuizConcluido> {

  String _appBarTitle;
  Quiz _quiz;
  TextEditingController _quantidadePerguntasController;
  TextEditingController _tituloController;
  TextEditingController _doencaController;
  TextEditingController _pontuacaoController;


  QuizConcluidoState(this._quiz, this._appBarTitle);

  @override
  void initState() {
    super.initState();
    _quantidadePerguntasController = new TextEditingController(text: _quiz.totalPerguntas.toString());
    _tituloController = new TextEditingController(text: _quiz.titulo);
    if(_quiz.doenca==null){
      _doencaController = new TextEditingController(text: 'Nenhuma doença específica');
    } else {
      _doencaController = new TextEditingController(text: _quiz.doenca.nome);
    }
    _pontuacaoController = new TextEditingController(text: _quiz.pontuacao.toString());
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
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  _logout(context);
                },
                icon: Icon(Icons.logout),
              )
            ],
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
              enabled: false,
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
            child: TextField(
              controller: _doencaController,
              style: textStyle,
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Doença',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  )
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextField(
              controller: _quantidadePerguntasController,
              style: textStyle,
              enabled: false,
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
            child: TextField(
              controller: _pontuacaoController,
              style: textStyle,
              enabled: false,
              decoration: InputDecoration(
                  labelText: 'Pontuação',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  )
              ),
            ),
          ),

                Container(width: 5.0,),
              ],
            ),
          ),

        ));
  }

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  void _logout(context) async {
    Login.registrarLogout();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }
}