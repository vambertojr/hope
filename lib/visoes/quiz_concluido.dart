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

  QuizConcluidoState(this._quiz, this._appBarTitle);

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
                  child: Text(
                    'Título: ${_quiz.titulo}',
                    style: textStyle,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    'Doença: ${_configurarDoenca()}',
                    style: textStyle,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    'Número de perguntas: ${_quiz.totalPerguntas.toString()}',
                    style: textStyle,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    'Pontuação: ${_quiz.pontuacao.toString()}',
                    style: textStyle,
                  ),
                ),

              ],
            ),
          ),

        ));
  }

  String _configurarDoenca(){
    if(_quiz.doenca==null){
      return 'Nenhuma doença específica';
    } else {
      return _quiz.doenca.nome;
    }
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