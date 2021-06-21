import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/resposta.dart';
import 'package:hope/visoes/componentes/caixa_dialogo.dart';
import 'package:hope/visoes/componentes/dialogo_termino.dart';
import 'package:hope/visoes/componentes/result_dialog.dart';

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
  int _indiceQuestao;
  List<Widget> _scoreKeeper;

  ResponderQuizState(this._quiz, this._appBarTitle);

  @override
  void initState() {
    super.initState();
    _indiceQuestao = 0;
    _scoreKeeper = [];
  }

  @override
  Widget build(BuildContext context) {

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

          body: _buildQuiz()
        ));
  }

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  _buildQuiz() {
    if (_quiz.perguntas.length == 0)
      return CaixaDialogo('Sem questões', icon: Icons.warning,);

    Pergunta pergunta = _quiz.perguntas[_indiceQuestao].pergunta;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _exibirPergunta(pergunta.texto),
        _exibirBotaoResposta(pergunta.alternativa1, 1),
        _exibirBotaoResposta(pergunta.alternativa2, 2),
        _exibirBotaoResposta(pergunta.alternativa3, 3),
        _exibirBotaoResposta(pergunta.alternativa4, 4),
        _exibirBotaoResposta(pergunta.alternativa5, 5),
        _buildScoreKeeper(),
      ],
    );
  }

  _exibirPergunta(String question) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  _exibirBotaoResposta(String textoResposta, int indice) {
    Resposta resposta = _quiz.perguntas[_indiceQuestao];
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.all(4.0),
            color: Colors.teal,
            child: Center(
              child: AutoSizeText(
                textoResposta,
                maxLines: 2,
                minFontSize: 10.0,
                maxFontSize: 32.0,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          onTap: () {
            resposta.valor = indice;
            _corrigirQuestao(resposta);
          },
        ),
      ),
    );
  }

  _corrigirQuestao(Resposta resposta){
    bool acertou = resposta.eCorreta();

    DialogoResultado.show(
      context,
      resposta: resposta,
      acertou: acertou,
      onNext: () {
        setState(() {
          _scoreKeeper.add(
            Icon(
              acertou ? Icons.check : Icons.close,
              color: acertou ? Colors.green : Colors.red,
            ),
          );

          if (_scoreKeeper.length < _quiz.perguntas.length) {
            _indiceQuestao++;
          } else {
            DialogoTermino.show(
                context,
                totalAcertos: _quiz.pontuacao,
                totalQuestoes: _quiz.perguntas.length,
                quiz: _quiz,
            );
          }
        });
      },
    );
  }

  _buildScoreKeeper() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _scoreKeeper,
      ),
    );
  }

}