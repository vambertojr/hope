import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/visoes/doenca_info.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
import 'package:hope/visoes/homepage.dart';

class ListaDoencas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaDoencasState();
  }
}

class ListaDoencasState extends State<ListaDoencas> {
  RepositorioDoenca _repositorioDoencas;
  RepositorioPergunta _repositorioPerguntas;
  List<Doenca> _listaDoencas;
  int _totalDoencas;

  @override
  void initState() {
    super.initState();
    _repositorioDoencas = RepositorioDoenca();
    _repositorioPerguntas = RepositorioPergunta();
    if (_listaDoencas == null) {
      _listaDoencas = [];
      _totalDoencas = 0;
      _atualizarListaDoencas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doenças"),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _logout(context);
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: _getListaDoencasView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _navigateToDetail(Doenca('', '', ''), 'Adicionar doença');
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
              child: Text(_getFirstLetter(this._listaDoencas[position].nome),
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
              _navigateToDetail(this._listaDoencas[position], 'Editar doença');
            },
          ),
        );
      },
    );
  }

  _getFirstLetter(String title) {
    if(title.length>2) return title.substring(0, 2);
    else return title.substring(0, 1);
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
        _apagar(contexto, doenca);
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

  void _apagar(BuildContext contexto, Doenca doenca) async {
    int resultado;
    bool existePergunta = await _repositorioPerguntas.existePerguntaSobreDoenca(doenca);

    if(existePergunta){
      doenca.ativa = false;
      resultado = await _repositorioDoencas.atualizarDoenca(doenca);
    } else {
      resultado = await _repositorioDoencas.apagarDoenca(doenca.id);
    }

    _voltarParaUltimaTela();

    if (resultado != 0) {
      _showSnackBar(contexto, 'Doença apagada com sucesso');
      _atualizarListaDoencas();
    } else {
      _showSnackBar(contexto, 'Erro ao apagar doença');
    }
  }

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _navigateToDetail(Doenca doenca, String titulo) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DoencaInfo(doenca, titulo);
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

  void _logout(context) async {
    Login.registrarLogout();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }


}