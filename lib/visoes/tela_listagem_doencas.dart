import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/visoes/componentes/gerenciador_componentes.dart';
import 'package:hope/visoes/tela_cadastro_doenca.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';

class TelaListagemDoencas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaListagemDoencasState();
  }
}

class TelaListagemDoencasState extends State<TelaListagemDoencas> {
  GerenciadorComponentes _gerenciadorComponentes;
  RepositorioDoenca _repositorioDoencas;
  RepositorioPergunta _repositorioPerguntas;
  List<Doenca> _listaDoencas;
  int _totalDoencas;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = GerenciadorComponentes();
    _repositorioDoencas = RepositorioDoenca();
    _repositorioPerguntas = RepositorioPergunta();

    if (_listaDoencas == null) {
      _listaDoencas = [];
      _totalDoencas = 0;
      _atualizarListaDoencas();
    }
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      appBar: _gerenciadorComponentes.configurarAppBar("Doenças", contexto),
      body: _getListaDoencasView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _navegarParaCadastroDoenca(Doenca('', '', ''), 'Adicionar doença');
        },
        tooltip: 'Adicionar doença',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ListView _getListaDoencasView() {
    return ListView.builder(
      itemCount: _totalDoencas,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(_gerenciadorComponentes.getPrimeirasLetras(this._listaDoencas[position].nome),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this._listaDoencas[position].nome,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this._listaDoencas[position].descricao),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _dialogoConfirmacaoExclusaoDoenca(context, _listaDoencas[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              _navegarParaCadastroDoenca(this._listaDoencas[position], 'Editar doença');
            },
          ),
        );
      },
    );
  }

  void _dialogoConfirmacaoExclusaoDoenca(BuildContext contexto, Doenca doenca){
    Widget botaoCancelar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(contexto).pop();
      },
    );

    Widget botaoContinuar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Continuar"),
      onPressed:  () {
        _apagar(doenca);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text('Confirmação'),
      content: Text('Você tem certeza que deseja apagar a doença?'),
      actions: [
        botaoCancelar,
        botaoContinuar,
      ],
    );

    showDialog(
      context: contexto,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _apagar(Doenca doenca) async {
    int resultado;
    bool existePergunta = await _repositorioPerguntas.existePerguntaSobreDoenca(doenca);

    if(existePergunta){
      doenca.ativa = false;
      resultado = await _repositorioDoencas.atualizarDoenca(doenca);
    } else {
      resultado = await _repositorioDoencas.apagarDoenca(doenca.id);
    }

    Navigator.pop(context, true);

    if (resultado != 0) {
      _exibirSnackBar(context, 'Doença apagada com sucesso');
      _atualizarListaDoencas();
    } else {
      _exibirSnackBar(context, 'Erro ao apagar doença');
    }
  }

  void _exibirSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navegarParaCadastroDoenca(Doenca doenca, String titulo) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TelaCadastroDoenca(doenca, titulo);
    }));

    if (result == true) {
      _atualizarListaDoencas();
    }
  }

  void _atualizarListaDoencas() {
    Future<List<Doenca>> listaDoencasFutura = _repositorioDoencas.getListaDoencasAtivas();
    listaDoencasFutura.then((listaDoencas) {
      setState(() {
        this._listaDoencas = listaDoencas;
        this._totalDoencas = listaDoencas.length;
      });
    });
  }

}