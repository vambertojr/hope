import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/visoes/doenca_info.dart';
import 'package:hope/repositorios/doenca_repositorio.dart';
import 'package:sqflite/sqflite.dart';

class ListaDoencas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaDoencasState();
  }
}

class ListaDoencasState extends State<ListaDoencas> {
  DoencaRepositorio databaseHelper = DoencaRepositorio();
  List<Doenca> listaDoencas;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (listaDoencas == null) {
      listaDoencas = List<Doenca>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("ADICIONAR DOENÇAS"),
        backgroundColor: Colors.teal,
      ),
      body: getListaDoencasView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Doenca.withId(-1, '', '', ''), 'Adicionar doença');
        },
        tooltip: 'Adicionar doença',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ListView getListaDoencasView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.listaDoencas[position].nome),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.listaDoencas[position].nome,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.listaDoencas[position].descricao),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, listaDoencas[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.listaDoencas[position], 'Editar doença');
              Colors.teal;
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Doenca doenca) async {
    int result = await databaseHelper.apagarDoenca(doenca.id);
    if (result != 0) {
      _showSnackBar(context, 'Doença apagada com sucesso');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Doenca doenca, String titulo) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DoencaInfo(doenca, titulo);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.inicializarDatabase();
    dbFuture.then((database) {
      Future<List<Doenca>> listaDoencasFutura = databaseHelper.getListaDoencas();
      listaDoencasFutura.then((listaDoencas) {
        setState(() {
          this.listaDoencas = listaDoencas;
          this.count = listaDoencas.length;
        });
      });
    });
  }


}