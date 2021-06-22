import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';

class PerguntaInfoController {

  RepositorioPergunta _repositorioPerguntas;
  RepositorioQuiz _repositorioQuiz;

  PerguntaInfoController():
        _repositorioPerguntas = RepositorioPergunta(),
        _repositorioQuiz = RepositorioQuiz();

  String validarAlternativa(String alternativa){
    String mensagem;
    if(alternativa.isEmpty){
      mensagem = "Informe a alternativa";
    }
    return mensagem;
  }

  String validarTexto(String texto){
    String mensagem;
    if(texto.isEmpty){
      mensagem = "Informe o texto da pergunta";
    }
    return mensagem;
  }

  Future<int> salvar(Pergunta pergunta) async {
    int resultado;
    if (pergunta.id != null) {
      resultado = await _repositorioPerguntas.atualizarPergunta(pergunta);
    } else {
      resultado = await _repositorioPerguntas.inserirPergunta(pergunta);
    }
    return resultado;
  }

  Future<int> apagar(Pergunta pergunta) async {
    int resultado;
    bool existeQuiz = await _repositorioQuiz.existeQuizQueUsaPergunta(pergunta);

    if(existeQuiz){
      pergunta.ativa = false;
      resultado = await _repositorioPerguntas.atualizarPergunta(pergunta);
    } else {
      resultado = await _repositorioPerguntas.apagarPergunta(pergunta.id);
    }
    return resultado;
  }

}