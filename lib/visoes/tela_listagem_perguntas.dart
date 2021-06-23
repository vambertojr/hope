import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';
import 'package:hope/visoes/tela_cadastro_pergunta.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/visoes/componentes/gerenciador_componentes.dart';
import 'package:unicorndial/unicorndial.dart';

class TelaListagemPerguntas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaListagemPerguntasState();
  }
}

class TelaListagemPerguntasState extends State<TelaListagemPerguntas> {
  GerenciadorComponentes _gerenciadorComponentes;
  RepositorioPergunta _repositorioPerguntas;
  RepositorioQuiz _repositorioQuiz;
  List<Pergunta> _listaPerguntas;
  int _totalPerguntas;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = GerenciadorComponentes();
    _repositorioPerguntas = RepositorioPergunta();
    _repositorioQuiz = RepositorioQuiz();
    if (_listaPerguntas == null) {
      _listaPerguntas = [];
      _totalPerguntas = 0;
      _atualizarListaPerguntas();
    }
  }

  @override
  Widget build(BuildContext contexto) {
    var botoes = <UnicornButton>[];

    Pergunta pergunta = Pergunta(new Doenca('','',''), '', '', '', null, null, null, 1);
    botoes.add(_configurarBotaoUnicorn('2 alternativas', '2', pergunta));

    pergunta = Pergunta(new Doenca('','',''), '', '', '', '', '', null, 1);
    botoes.add(_configurarBotaoUnicorn('4 alternativas', '4', pergunta));

    pergunta = Pergunta(new Doenca('','',''), '', '', '', '', '', '', 1);
    botoes.add(_configurarBotaoUnicorn('5 alternativas', '5', pergunta));

    return Scaffold(
      appBar: _gerenciadorComponentes.configurarAppBar("Perguntas", contexto),
      body: _getListaPerguntasView(),
      floatingActionButton: UnicornDialer(
          backgroundColor: Colors.black45,
          parentButtonBackground: Colors.teal,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: botoes),
    );
  }

  UnicornButton _configurarBotaoUnicorn(String label, String texto, Pergunta pergunta){
    return UnicornButton(
        hasLabel: true,
        labelText: label,
        currentButton: FloatingActionButton(
          heroTag: texto,
          backgroundColor: Colors.teal,
          mini: true,
          child: Text(texto),
          onPressed: () {
            _navegarParaCadastroPergunta(pergunta, 'Adicionar pergunta');
          },
        ));
  }

  ListView _getListaPerguntasView() {
    return ListView.builder(
      itemCount: _totalPerguntas,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(_gerenciadorComponentes.getPrimeirasLetras(this._listaPerguntas[position].doenca.nome),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this._listaPerguntas[position].texto,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this._listaPerguntas[position].doenca.nome),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _dialogoConfirmacaoExclusaoPergunta(context, _listaPerguntas[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              _navegarParaCadastroPergunta(this._listaPerguntas[position], 'Editar pergunta');
            },
          ),
        );
      },
    );
  }

  void _dialogoConfirmacaoExclusaoPergunta(BuildContext context, Pergunta pergunta){
    Widget botaoCancelar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget botaoContinuar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Continuar"),
      onPressed:  () {
        _apagar(context, pergunta);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('Confirmação'),
      content: Text('Você tem certeza que deseja apagar a pergunta?'),
      actions: [
        botaoCancelar,
        botaoContinuar,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _apagar(BuildContext contexto, Pergunta pergunta) async {
    int resultado;
    bool existeQuiz = await _repositorioQuiz.existeQuizQueUsaPergunta(pergunta);
    if(existeQuiz){
      pergunta.ativa = false;
      resultado = await _repositorioPerguntas.atualizarPergunta(pergunta);
    } else {
      resultado = await _repositorioPerguntas.apagarPergunta(pergunta.id);
    }

    _gerenciadorComponentes.voltarParaUltimaTela(contexto);

    if (resultado != 0) {
      _exibirSnackBar(contexto, 'Pergunta apagada com sucesso');
      _atualizarListaPerguntas();
    } else {
      _exibirSnackBar(contexto, 'Erro ao apagar pergunta');
    }
  }

  void _exibirSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navegarParaCadastroPergunta(Pergunta pergunta, String titulo) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TelaCadastroPergunta(pergunta, titulo);
    }));

    if (result == true) {
      _atualizarListaPerguntas();
    }
  }

  void _atualizarListaPerguntas() {
    Future<List<Pergunta>> listaPerguntasFutura = _repositorioPerguntas.getListaPerguntasAtivas();
    listaPerguntasFutura.then((listaPerguntas) {
      setState(() {
        this._listaPerguntas = listaPerguntas;
        this._listaPerguntas.sort((a, b) => a.doenca.nome.compareTo(b.doenca.nome));
        this._totalPerguntas = listaPerguntas.length;
      });
    });
  }

}