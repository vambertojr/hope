import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/visoes/pergunta_info.dart';
import 'package:hope/repositorios/pergunta_repositorio.dart';
import 'package:sqflite/sqflite.dart';

class ListaPerguntas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaPerguntasState();
  }
}

class ListaPerguntasState extends State<ListaPerguntas> {
  PerguntaRepositorio databaseHelper = PerguntaRepositorio();
  List<Pergunta> listaPerguntas;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (listaPerguntas == null) {
      listaPerguntas = List<Pergunta>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("ADICIONAR PERGUNTAS"),
        backgroundColor: Colors.teal,
      ),
      body: getListaPerguntasView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(Pergunta(null, '', '', '', '', '', '', 1), 'Adicionar Pergunta');
        },
        tooltip: 'Adicionar pergunta',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  ListView getListaPerguntasView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.listaPerguntas[position].texto),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.listaPerguntas[position].texto,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.listaPerguntas[position].texto),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, listaPerguntas[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.listaPerguntas[position], 'Editar Pergunta');
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

  void _delete(BuildContext context, Pergunta pergunta) async {
    int result = await databaseHelper.apagarPergunta(pergunta.id);
    if (result != 0) {
      _showSnackBar(context, 'Pergunta apagada com sucesso');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Pergunta pergunta, String titulo) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PerguntaInfo(pergunta, titulo);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.inicializarDatabase();
    dbFuture.then((database) {
      Future<List<Pergunta>> listaPerguntasFutura = databaseHelper.getListaPerguntas();
      listaPerguntasFutura.then((listaPerguntas) {
        setState(() {
          this.listaPerguntas = listaPerguntas;
          this.count = listaPerguntas.length;
        });
      });
    });
  }


}