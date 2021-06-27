import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';
import 'package:hope/visoes/tela_informacao_doenca.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';

class TelaListagemDoencasSemEdicao extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TelaListagemDoencasSemEdicaoState();
  }
}

class TelaListagemDoencasSemEdicaoState extends State<TelaListagemDoencasSemEdicao> {

  ComponentesUtil _gerenciadorComponentes;
  RepositorioDoenca _repositorioDoencas;
  List<Doenca> _listaDoencas;
  int _totalDoencas;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    _repositorioDoencas = RepositorioDoenca();

    if (_listaDoencas == null) {
      _listaDoencas = [];
      _totalDoencas = 0;
      _atualizarListaDoencas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _gerenciadorComponentes.appBar("Doenças", context),
      body: _getListaDoencasView(),
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
            onTap: () {
              _navegarParaCadastroDoenca(this._listaDoencas[position], this._listaDoencas[position].nome);
            },
          ),
        );
      },
    );
  }

  void _navegarParaCadastroDoenca(Doenca doenca, String titulo) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TelaInformacaoDoenca(doenca, titulo);
    }));
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