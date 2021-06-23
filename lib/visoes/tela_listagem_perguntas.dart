import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/controladores/pergunta_controller.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/visoes/componentes/dialogo_confirmacao_exclusao.dart';
import 'package:hope/visoes/tela_cadastro_pergunta.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';
import 'package:unicorndial/unicorndial.dart';

class TelaListagemPerguntas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaListagemPerguntasState();
  }
}

class TelaListagemPerguntasState extends State<TelaListagemPerguntas> {

  ComponentesUtil _gerenciadorComponentes;
  RepositorioPergunta _repositorioPerguntas;
  List<Pergunta> _listaPerguntas;
  int _totalPerguntas;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    _repositorioPerguntas = RepositorioPergunta();
    if (_listaPerguntas == null) {
      _listaPerguntas = [];
      _totalPerguntas = 0;
      _atualizarListaPerguntas();
    }
  }

  @override
  Widget build(BuildContext context) {
    var botoes = <UnicornButton>[];

    Pergunta pergunta = Pergunta(new Doenca('','',''), '', '', '', null, null, null, 1);
    botoes.add(_configurarBotaoUnicorn('2 alternativas', '2', pergunta));

    pergunta = Pergunta(new Doenca('','',''), '', '', '', '', '', null, 1);
    botoes.add(_configurarBotaoUnicorn('4 alternativas', '4', pergunta));

    pergunta = Pergunta(new Doenca('','',''), '', '', '', '', '', '', 1);
    botoes.add(_configurarBotaoUnicorn('5 alternativas', '5', pergunta));

    return Scaffold(
      appBar: _gerenciadorComponentes.appBar("Perguntas", context),
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
                    String mensagem = 'Você tem certeza que deseja apagar a pergunta?';
                    DialogoConfirmacaoExclusao.showObject(context, mensagem: mensagem, apagar: _apagar,
                        argumento: _listaPerguntas[position]);
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

  void _apagar(Object object) async {
    Pergunta pergunta = object;
    PerguntaController perguntaController = PerguntaController(pergunta);
    int resultado = await perguntaController.apagar();

    Navigator.pop(context, true);

    if (resultado != 0) {
      _exibirSnackBar('Pergunta apagada com sucesso');
      _atualizarListaPerguntas();
    } else {
      _exibirSnackBar('Erro ao apagar pergunta');
    }
  }

  void _exibirSnackBar(String message) {
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