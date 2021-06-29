import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';

class DoencaController {

  Doenca _doenca;
  RepositorioPergunta _repositorioPerguntas;
  RepositorioDoenca _repositorioDoencas;
  RepositorioQuiz _repositorioQuiz;

  DoencaController(this._doenca):
        _repositorioPerguntas = RepositorioPergunta(),
        _repositorioDoencas = RepositorioDoenca(),
        _repositorioQuiz = RepositorioQuiz();

  Future<int> apagar() async {
    int resultado;
    List<Pergunta> perguntas = await _repositorioPerguntas.getPerguntasSobreDoenca(_doenca);

    if(perguntas.isEmpty){
      resultado = await _repositorioDoencas.apagarDoenca(_doenca.id);
    } else {
      resultado = await _desabilitarDoenca();

      bool existeQuiz = await _existeQuizComAlgumaPerguntaDeInteresse(perguntas);
      if(existeQuiz) {
        await _desabilitarPerguntas(perguntas);
      } else {
        await _apagarPerguntas(perguntas);
      }
    }
    return resultado;
  }

  Future<int> salvar() async {
    int resultado;
    if (_doenca.id != null) {
      resultado = await _repositorioDoencas.atualizarDoenca(_doenca);
    } else {
      resultado = await _repositorioDoencas.inserirDoenca(_doenca);
    }
    return resultado;
  }

  _desabilitarDoenca() async {
    _doenca.ativa = false;
    return await _repositorioDoencas.atualizarDoenca(_doenca);
  }

  _desabilitarPerguntas(List<Pergunta> perguntas) async {
    for(int i=0; i<perguntas.length; i++){
      perguntas[i].ativa = false;
      await _repositorioPerguntas.atualizarPergunta(perguntas[i]);
    }
  }

  _apagarPerguntas(List<Pergunta> perguntas) async {
    for(int i=0; i<perguntas.length; i++){
      perguntas[i].ativa = false;
      await _repositorioPerguntas.apagarPergunta(perguntas[i].id);
    }
  }

  Future<bool> _existeQuizComAlgumaPerguntaDeInteresse(List<Pergunta> perguntas) async {
    bool existeQuiz = false;
    for(int i=0; i<perguntas.length; i++){
      existeQuiz = await _repositorioQuiz.existeQuizQueUsaPergunta(perguntas[i]);
      if(existeQuiz) break;
    }
    return existeQuiz;
  }

}