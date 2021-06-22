import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/visoes/homepage.dart';
import 'package:hope/visoes/pergunta_info.dart';
import 'package:hope/repositorios/pergunta_repositorio.dart';
import 'package:unicorndial/unicorndial.dart';

class ListaPerguntas extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListaPerguntasState();
  }
}

class ListaPerguntasState extends State<ListaPerguntas> {
  PerguntaRepositorio _databaseHelper = PerguntaRepositorio();
  List<Pergunta> _listaPerguntas;
  int _totalPerguntas;

  @override
  void initState() {
    super.initState();
    if (_listaPerguntas == null) {
      _listaPerguntas = [];
      _totalPerguntas = 0;
      _atualizarListaPerguntas();
    }
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = <UnicornButton>[];

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "2 alternativas",
        currentButton: FloatingActionButton(
          heroTag: "2",
          backgroundColor: Colors.teal,
          mini: true,
          child: Text('2'),
          onPressed: () {
            navigateToDetail(Pergunta(new Doenca('','',''), '', '', '', null, null, null, 1), 'Adicionar pergunta');
          },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "4 alternativas",
        currentButton: FloatingActionButton(
            heroTag: "4",
            backgroundColor: Colors.teal,
            mini: true,
            child: Text('4'),
            onPressed: () {
              navigateToDetail(Pergunta(new Doenca('','',''), '', '', '', '', '', null, 1), 'Adicionar pergunta');
            },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "5 alternativas",
        currentButton: FloatingActionButton(
            heroTag: "5",
            backgroundColor: Colors.teal,
            mini: true,
            child: Text('5'),
            onPressed: () {
              navigateToDetail(Pergunta(new Doenca('','',''), '', '', '', '', '', '', 1), 'Adicionar pergunta');
            },
        )));

    return Scaffold(
      appBar: AppBar(
        title: Text("Perguntas"),
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
      body: getListaPerguntasView(),
      floatingActionButton: UnicornDialer(
          backgroundColor: Colors.black45,
          parentButtonBackground: Colors.teal,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: childButtons),
    );
  }

  ListView getListaPerguntasView() {
    return ListView.builder(
      itemCount: _totalPerguntas,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this._listaPerguntas[position].doenca.nome),
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
                    _delete(context, _listaPerguntas[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              navigateToDetail(this._listaPerguntas[position], 'Editar pergunta');
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
    int result = await _databaseHelper.apagarPergunta(pergunta.id);
    if (result != 0) {
      _showSnackBar(context, 'Pergunta apagada com sucesso');
      _atualizarListaPerguntas();
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
      _atualizarListaPerguntas();
    }
  }

  void _atualizarListaPerguntas() {
    Future<List<Pergunta>> listaPerguntasFutura = _databaseHelper.getListaPerguntas();
    listaPerguntasFutura.then((listaPerguntas) {
      setState(() {
        this._listaPerguntas = listaPerguntas;
        this._listaPerguntas.sort((a, b) => a.doenca.nome.compareTo(b.doenca.nome));
        this._totalPerguntas = listaPerguntas.length;
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