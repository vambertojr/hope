import 'package:hope/modelos/doenca.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';

class DoencaController {

  Doenca _doenca;
  RepositorioPergunta _repositorioPerguntas;
  RepositorioDoenca _repositorioDoencas;

  DoencaController(this._doenca):
        _repositorioPerguntas = RepositorioPergunta(),
        _repositorioDoencas = RepositorioDoenca();

  Future<int> apagar() async {
    int resultado;
    bool existePergunta = await _repositorioPerguntas.existePerguntaSobreDoenca(_doenca);
    if(existePergunta){
      _doenca.ativa = false;
      resultado = await _repositorioDoencas.atualizarDoenca(_doenca);
    } else {
      resultado = await _repositorioDoencas.apagarDoenca(_doenca.id);
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

}