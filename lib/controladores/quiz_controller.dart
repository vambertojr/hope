import 'dart:math';

import 'package:hope/modelos/pergunta.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/resposta.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';

class QuizController {

  Quiz _quiz;
  RepositorioPergunta _repositorioPerguntas;

  QuizController(this._quiz):
        _repositorioPerguntas = RepositorioPergunta();

  Quiz get quiz => _quiz;

  set quiz(Quiz value) {
    _quiz = value;
  }

  List _embaralhar(List<Pergunta> itens) {
    Random random = new Random();
    for (int i=itens.length-1; i>0; i--) {
      int n = random.nextInt(i+1);
      Pergunta temp = itens[i];
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

  Future<int> sortearPerguntas() async {
    int resultado = 1; //0 - nao gerou, 1 - gerou sem alerta, 2 - gerou com alerta
    List<Pergunta> todasAsPerguntas;
    if(_quiz.doenca.id != null){
      todasAsPerguntas = await _repositorioPerguntas.getListaPerguntasAtivasPorDoenca(_quiz.doenca);
    } else {
      todasAsPerguntas = await _repositorioPerguntas.getListaPerguntasAtivas();
    }

    if(todasAsPerguntas==null || todasAsPerguntas.isEmpty){
      resultado = 0;
    } else if(todasAsPerguntas.length<_quiz.totalPerguntas){
      _quiz.perguntas = _converterParaListaRespostas(_embaralhar(todasAsPerguntas));
      _quiz.totalPerguntas = _quiz.perguntas.length;
      resultado = 2;
    } else if(todasAsPerguntas.length==_quiz.totalPerguntas){
      _quiz.perguntas = _converterParaListaRespostas(_embaralhar(todasAsPerguntas));
    } else {
      Random random = new Random();
      _quiz.perguntas = [];
      while(_quiz.perguntas.length<_quiz.totalPerguntas){
        int indice = random.nextInt(todasAsPerguntas.length);
        Pergunta pergunta = todasAsPerguntas[indice];
        if(!_perguntaJaFoiSelecionada(pergunta)){
          _quiz.perguntas.add(new Resposta(0, pergunta));
        }
      }
    }
    return resultado;
  }

  bool _perguntaJaFoiSelecionada(Pergunta perguntaDeInteresse){
    List<Pergunta> perguntas = [];
    for(int i=0; i<_quiz.perguntas.length; i++){
      perguntas.add(_quiz.perguntas[i].pergunta);
    }
    return perguntas.contains(perguntaDeInteresse);
  }

}