import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/resposta.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';
import 'package:hope/visoes/componentes/dialogo.dart';
import 'package:hope/visoes/componentes/dialogo_fim_quiz.dart';
import 'package:hope/visoes/componentes/dialogo_resultado_por_pergunta.dart';
import 'package:hope/visoes/componentes/gerenciador_componentes.dart';

class TelaResponderQuiz extends StatefulWidget {

  final String tituloAppBar;
  final Quiz quiz;

  TelaResponderQuiz(this.quiz, this.tituloAppBar);

  @override
  State<StatefulWidget> createState() {
    return TelaResponderQuizState(this.quiz, this.tituloAppBar);
  }
}

class TelaResponderQuizState extends State<TelaResponderQuiz> {
  GerenciadorComponentes _gerenciadorComponentes;
  String _tituloAppBar;
  Quiz _quiz;
  int _indiceQuestao;
  List<Widget> _scoreKeeper;

  TelaResponderQuizState(this._quiz, this._tituloAppBar);

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = GerenciadorComponentes();
    _indiceQuestao = 0;
    _scoreKeeper = [];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return _gerenciadorComponentes.voltarParaUltimaTela(context);
        },

        child: Scaffold(
          appBar: _gerenciadorComponentes.configurarAppBar(_tituloAppBar, context),
          body: _configurarQuiz()
        ));
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

  _configurarQuiz() {
    if (_quiz.perguntas.length == 0)
      return Dialogo('Sem questões', icon: Icons.warning,);

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
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            question,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23.0,
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

    DialogoResultadoPorPergunta.show(
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
            DialogoFimQuiz.show(
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
    RepositorioQuiz repositorio = new RepositorioQuiz();
    await repositorio.inserirQuiz(_quiz);
  }

}