import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/database_helper.dart';
import 'package:hope/repositorios/doenca_repositorio.dart';
import 'package:hope/repositorios/pergunta_repositorio.dart';
import 'package:sqflite/sqflite.dart';


class PerguntaInfo extends StatefulWidget {

  final String appBarTitle;
  final Pergunta pergunta;

  PerguntaInfo(this.pergunta, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return PerguntaInfoState(this.pergunta, this.appBarTitle);
  }
}

class PerguntaInfoState extends State<PerguntaInfo> {

  PerguntaRepositorio _perguntasRepositorio;
  DoencaRepositorio _doencasRepositorio;

  String appBarTitle;
  Pergunta pergunta;
  List<Doenca> doencasLista;
  Doenca _doencaSelecionada;
  int _gabarito;
  List<DropdownMenuItem<Doenca>> _menuDoencas;

  TextEditingController _textoController;
  TextEditingController _alternativa1Controller;
  TextEditingController _alternativa2Controller;
  TextEditingController _alternativa3Controller;
  TextEditingController _alternativa4Controller;
  TextEditingController _alternativa5Controller;

  PerguntaInfoState(this.pergunta, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _perguntasRepositorio = PerguntaRepositorio();
    _doencasRepositorio = DoencaRepositorio();
    _textoController = new TextEditingController(text: pergunta.texto);
    _alternativa1Controller = new TextEditingController(text: pergunta.alternativa1);
    _alternativa2Controller = new TextEditingController(text: pergunta.alternativa2);
    _alternativa3Controller = new TextEditingController(text: pergunta.alternativa3);
    _alternativa4Controller = new TextEditingController(text: pergunta.alternativa4);
    _alternativa5Controller = new TextEditingController(text: pergunta.alternativa5);
    _gabarito = pergunta.gabarito?.toString()?.isEmpty ? 1 : pergunta.gabarito;
    _inicializarMenuDoencas();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            backgroundColor: Colors.teal,
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: DropdownButtonFormField<Doenca>(
                    value: _doencaSelecionada,
                    onChanged: (doenca) {
                      setState(() {
                        atualizarDoenca(doenca);
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Doença',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    items: _menuDoencas,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _textoController,
                    style: textStyle,
                    minLines: 3,
                    maxLines: 10,
                    onChanged: (value) {
                      atualizarTexto();
                    },
                    decoration: InputDecoration(
                        labelText: 'Texto',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _alternativa1Controller,
                    style: textStyle,
                    onChanged: (value) {
                      atualizarAlternativa(1, _alternativa1Controller);
                    },
                    decoration: InputDecoration(
                        labelText: 'Alternativa 1',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _alternativa2Controller,
                    style: textStyle,
                    onChanged: (value) {
                      atualizarAlternativa(2, _alternativa2Controller);
                    },
                    decoration: InputDecoration(
                        labelText: 'Alternativa 2',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _alternativa3Controller,
                    style: textStyle,
                    onChanged: (value) {
                      atualizarAlternativa(3, _alternativa3Controller);
                    },
                    decoration: InputDecoration(
                        labelText: 'Alternativa 3',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _alternativa4Controller,
                    style: textStyle,
                    onChanged: (value) {
                      atualizarAlternativa(4, _alternativa4Controller);
                    },
                    decoration: InputDecoration(
                        labelText: 'Alternativa 4',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: _alternativa5Controller,
                    style: textStyle,
                    onChanged: (value) {
                      atualizarAlternativa(5, _alternativa5Controller);
                    },
                    decoration: InputDecoration(
                        labelText: 'Alternativa 5',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: DropdownButtonFormField<int>(
                    value: _gabarito,
                    onChanged: (value) {
                      _gabarito = value;
                      atualizarGabarito();
                    },
                    decoration: InputDecoration(
                        labelText: 'Gabarito',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    items: <int>[1, 2, 3, 4, 5]
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: Text(
                            'Salvar',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                              setState(() {
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: Text(
                            'Deletar',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),

        ));
  }

  void _atualizarDoencasLista(){
    _menuDoencas = doencasLista.map((doenca) => DropdownMenuItem<Doenca>(
      child: Text(doenca.nome),
      value: doenca,
    )
    ).toList();
  }

  void _inicializarMenuDoencas() async {
      this.doencasLista = [];
      Future<List<Doenca>> listaDoencasFutura = _doencasRepositorio.getListaDoencas();
      listaDoencasFutura.then((listaDoencas) {
        setState(() {
          this.doencasLista = listaDoencas;
          _atualizarDoencasLista();
          _inicializarDoencaSelecionada();
        });
      });
  }

  void _inicializarDoencaSelecionada(){
    if(pergunta.doenca == null || pergunta.doenca.nome.isEmpty){
      pergunta.doenca = this.doencasLista[0];
    }
    this._doencaSelecionada = pergunta.doenca;
  }

  void atualizarDoenca(Doenca doenca){
    _doencaSelecionada = doenca;
    pergunta.doenca = _doencaSelecionada;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void atualizarTexto(){
    pergunta.texto = _textoController.text;
  }

  void atualizarAlternativa(int index, TextEditingController controller) {
    switch(index){
      case 1: pergunta.alternativa1 = controller.text;
        break;
      case 2: pergunta.alternativa2 = controller.text;
        break;
      case 3: pergunta.alternativa3 = controller.text;
        break;
      case 4: pergunta.alternativa4 = controller.text;
        break;
      case 5: pergunta.alternativa5 = controller.text;
        break;
    }
  }

  void atualizarGabarito(){
    pergunta.gabarito = _gabarito;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    int result;
    if (pergunta.id != null) {  // Case 1: Update operation
      result = await _perguntasRepositorio.atualizarPergunta(pergunta);
    } else { // Case 2: Insert Operation
      result = await _perguntasRepositorio.inserirPergunta(pergunta);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Pergunta salva com sucesso');
    } else {  // Failure
      _showAlertDialog('Status', 'Erro ao salvar pergunta');
    }

  }

  void _delete() async {

    moveToLastScreen();

    if (pergunta.id == null) {
      _showAlertDialog('Status', 'Nenhuma pergunta foi apagada');
      return;
    }

    int result = await _perguntasRepositorio.apagarPergunta(pergunta.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Pergunta apagada com sucesso');
    } else {
      _showAlertDialog('Status', 'Erro ao apagar pergunta');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      backgroundColor: Colors.white,
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}