import 'package:flutter/material.dart';
import 'package:hope/modelos/quiz.dart';

class ResponderQuiz extends StatefulWidget {

  final String appBarTitle;
  final Quiz quiz;

  ResponderQuiz(this.quiz, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ResponderQuizState(this.quiz, this.appBarTitle);
  }
}

class ResponderQuizState extends State<ResponderQuiz> {
  String _appBarTitle;
  Quiz _quiz;

  ResponderQuizState(this._quiz, this._appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(

        onWillPop: () {
          _voltarParaUltimaTela();
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

          //body:

        ));
  }

  void _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

}