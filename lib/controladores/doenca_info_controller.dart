import 'package:hope/modelos/doenca.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';

class DoencaInfoController {

  RepositorioDoenca _repositorioDoencas;
  RepositorioPergunta _repositorioPerguntas;

  DoencaInfoController():
        _repositorioDoencas = RepositorioDoenca(),
        _repositorioPerguntas = RepositorioPergunta();

  Future<int> salvar(Doenca doenca) async {
    int resultado;
    if (doenca.id != null) {
      resultado = await _repositorioDoencas.atualizarDoenca(doenca);
    } else {
      resultado = await _repositorioDoencas.inserirDoenca(doenca);
    }
    resultado;
  }

  Future<int> apagar(Doenca doenca) async {
    int resultado;
    bool existePergunta = await _repositorioPerguntas.existePerguntaSobreDoenca(doenca);
    if(existePergunta){
      doenca.ativa = false;
      resultado = await _repositorioDoencas.atualizarDoenca(doenca);
    } else {
      resultado = await _repositorioDoencas.apagarDoenca(doenca.id);
    }
    return resultado;
  }

  String validarNome(String nome){
    String mensagem;
    if(nome.isEmpty){
      mensagem = "Informe o nome da doença";
    }
    return mensagem;
  }

}