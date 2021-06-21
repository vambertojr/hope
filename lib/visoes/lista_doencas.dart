import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/visoes/doenca_info.dart';
import 'package:hope/repositorios/doenca_repositorio.dart';
import 'package:hope/visoes/homepage.dart';

class ListaDoencas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaDoencasState();
  }
}

class ListaDoencasState extends State<ListaDoencas> {
  DoencaRepositorio _databaseHelper;
  List<Doenca> _listaDoencas;
  int _totalDoencas;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DoencaRepositorio();
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
                    _delete(context, _listaDoencas[position]);
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
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Doenca doenca) async {
    int result = await _databaseHelper.apagarDoenca(doenca.id);
    if (result != 0) {
      _showSnackBar(context, 'Doença apagada com sucesso');
      _atualizarListaDoencas();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
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
    Future<List<Doenca>> listaDoencasFutura = _databaseHelper.getListaDoencas();
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