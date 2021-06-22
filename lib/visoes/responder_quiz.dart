import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/resposta.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:hope/repositorios/quiz_repositorio.dart';
import 'package:hope/visoes/componentes/caixa_dialogo.dart';
import 'package:hope/visoes/componentes/dialogo_termino.dart';
import 'package:hope/visoes/componentes/dialogo_resultado.dart';

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

  int _getNumeroAlternativas(Pergunta pergunta){
    int alternativasNull = 0;
    List<String> alternativas = [pergunta.alternativa1, pergunta.alternativa2,
      pergunta.alternativa3, pergunta.alternativa4, pergunta.alternativa5];

    for(int i=0; i<alternativas.length; i++){
      if(alternativas[i] == null || alternativas[i] == '') alternativasNull++;
    }

    return (5 - alternativasNull);
  }

  _buildQuiz() {
    if (_quiz.perguntas.length == 0)
      return CaixaDialogo('Sem questões', icon: Icons.warning,);

    Pergunta pergunta = _quiz.perguntas[_indiceQuestao].pergunta;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _configurarListaWidgets(pergunta),
    );
  }

  List<Widget> _configurarListaWidgets(Pergunta pergunta){
    int numeroAlternativas = _getNumeroAlternativas(pergunta);

    List<Widget> widgets = <Widget>[];
    widgets.add(_configurarExibicaoPergunta(pergunta.texto));
    widgets.add(_configurarBotaoResposta(pergunta.alternativa1, 1));
    widgets.add(_configurarBotaoResposta(pergunta.alternativa2, 2));

    if(numeroAlternativas>2){
      widgets.add(_configurarBotaoResposta(pergunta.alternativa3, 3));
      widgets.add(_configurarBotaoResposta(pergunta.alternativa4, 4));
    }

    if(numeroAlternativas==5){
      widgets.add(_configurarBotaoResposta(pergunta.alternativa5, 5));
    }

    widgets.add(_configurarExibicaoPontuacaoAtual());

    return widgets;
  }

  _configurarExibicaoPergunta(String question) {
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

  _configurarBotaoResposta(String textoResposta, int indice) {
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

  _corrigirQuestao(Resposta resposta) {
    bool acertou = resposta.eCorreta();
    if(acertou) _quiz.pontuacao++;

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
            _salvarQuiz();
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

  _configurarExibicaoPontuacaoAtual() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _scoreKeeper,
      ),
    );
  }

  _salvarQuiz() async {
    QuizRepositorio repositorio = new QuizRepositorio();
    var resultado = await repositorio.inserirQuiz(_quiz);
    if (resultado != 0) {
     print('Quiz salvo com sucesso');
    } else {
      print('Erro ao salvar quiz');
    }
  }

}