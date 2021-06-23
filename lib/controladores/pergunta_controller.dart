import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';

class PerguntaController {

  Pergunta _pergunta;
  RepositorioPergunta _repositorioPerguntas;
  RepositorioQuiz _repositorioQuiz;

  PerguntaController(this._pergunta):
        _repositorioPerguntas = RepositorioPergunta(),
        _repositorioQuiz = RepositorioQuiz();

  Future<int> apagar() async {
    int resultado;
    bool existeQuiz = await _repositorioQuiz.existeQuizQueUsaPergunta(_pergunta);

    if(existeQuiz){
      _pergunta.ativa = false;
      resultado = await _repositorioPerguntas.atualizarPergunta(_pergunta);
    } else {
      resultado = await _repositorioPerguntas.apagarPergunta(_pergunta.id);
    }
    return resultado;
  }

  Future<int> salvar() async {
    int resultado;
    if (_pergunta.id != null) {
      resultado = await _repositorioPerguntas.atualizarPergunta(_pergunta);
    } else {
      resultado = await _repositorioPerguntas.inserirPergunta(_pergunta);
    }
    return resultado;
  }

}