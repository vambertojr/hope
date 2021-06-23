import 'package:flutter/material.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';


class TelaVisaoQuizConcluido extends StatefulWidget {

  final String tituloAppBar;
  final Quiz quiz;

  TelaVisaoQuizConcluido(this.quiz, this.tituloAppBar);

  @override
  State<StatefulWidget> createState() {
    return TelaVisaoQuizConcluidoState(this.quiz, this.tituloAppBar);
  }
}

class TelaVisaoQuizConcluidoState extends State<TelaVisaoQuizConcluido> {
  ComponentesUtil _gerenciadorComponentes;
  String _tituloAppBar;
  Quiz _quiz;
  TextEditingController _quantidadePerguntasController;
  TextEditingController _tituloController;
  TextEditingController _doencaController;
  TextEditingController _pontuacaoController;


  TelaVisaoQuizConcluidoState(this._quiz, this._tituloAppBar);

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
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
          return _gerenciadorComponentes.voltarParaUltimaTela(context);
        },

        child: Scaffold(
          appBar: _gerenciadorComponentes.appBar(_tituloAppBar, context),
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

}