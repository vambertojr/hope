import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/doenca_repositorio.dart';
import 'package:hope/repositorios/pergunta_repositorio.dart';
import 'package:hope/visoes/homepage.dart';


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

  String _appBarTitle;
  Pergunta _pergunta;
  List<Doenca> _doencasLista;
  Doenca _doencaSelecionada;
  int _gabarito;
  List<DropdownMenuItem<Doenca>> _menuDoencas;

  TextEditingController _textoController;
  TextEditingController _alternativa1Controller;
  TextEditingController _alternativa2Controller;
  TextEditingController _alternativa3Controller;
  TextEditingController _alternativa4Controller;
  TextEditingController _alternativa5Controller;

  PerguntaInfoState(this._pergunta, this._appBarTitle);

  @override
  void initState() {
    super.initState();
    _perguntasRepositorio = PerguntaRepositorio();
    _doencasRepositorio = DoencaRepositorio();
    _textoController = new TextEditingController(text: _pergunta.texto);
    _alternativa1Controller = new TextEditingController(text: _pergunta.alternativa1);
    _alternativa2Controller = new TextEditingController(text: _pergunta.alternativa2);
    _alternativa3Controller = new TextEditingController(text: _pergunta.alternativa3);
    _alternativa4Controller = new TextEditingController(text: _pergunta.alternativa4);
    _alternativa5Controller = new TextEditingController(text: _pergunta.alternativa5);
    _gabarito = _pergunta.gabarito.toString().isEmpty ? 1 : _pergunta.gabarito;
    _inicializarMenuDoencas();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(

        onWillPop: () {
          return _voltarParaUltimaTela();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(_appBarTitle),
            backgroundColor: Colors.teal,
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  _voltarParaUltimaTela();
                }
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  _logout(context);
                },
                icon: Icon(Icons.logout),
              )
            ],
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
                      _atualizarTexto();
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
                      _atualizarAlternativa(1, _alternativa1Controller);
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
                      _atualizarAlternativa(2, _alternativa2Controller);
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
                      _atualizarAlternativa(3, _alternativa3Controller);
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
                      _atualizarAlternativa(4, _alternativa4Controller);
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
                      _atualizarAlternativa(5, _alternativa5Controller);
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
                      _atualizarGabarito();
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
    _menuDoencas = _doencasLista.map((doenca) => DropdownMenuItem<Doenca>(
      child: Text(doenca.nome),
      value: doenca,
    )
    ).toList();
  }

  void _inicializarMenuDoencas() async {
      this._doencasLista = [];
      Future<List<Doenca>> listaDoencasFutura = _doencasRepositorio.getListaDoencas();
      listaDoencasFutura.then((listaDoencas) {
        setState(() {
          this._doencasLista = listaDoencas;
          _atualizarDoencasLista();
          _inicializarDoencaSelecionada();
        });
      });
  }

  void _inicializarDoencaSelecionada(){
    if(_pergunta.doenca == null || _pergunta.doenca.nome.isEmpty){
      _pergunta.doenca = this._doencasLista[0];
    }
    this._doencaSelecionada = _pergunta.doenca;
  }

  void atualizarDoenca(Doenca doenca){
    _doencaSelecionada = doenca;
    _pergunta.doenca = _doencaSelecionada;
  }

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  void _atualizarTexto(){
    _pergunta.texto = _textoController.text;
  }

  void _atualizarAlternativa(int index, TextEditingController controller) {
    switch(index){
      case 1: _pergunta.alternativa1 = controller.text;
        break;
      case 2: _pergunta.alternativa2 = controller.text;
        break;
      case 3: _pergunta.alternativa3 = controller.text;
        break;
      case 4: _pergunta.alternativa4 = controller.text;
        break;
      case 5: _pergunta.alternativa5 = controller.text;
        break;
    }
  }

  void _atualizarGabarito(){
    _pergunta.gabarito = _gabarito;
  }

  void _save() async {
    _voltarParaUltimaTela();

    int result;
    if (_pergunta.id != null) {
      result = await _perguntasRepositorio.atualizarPergunta(_pergunta);
    } else {
      result = await _perguntasRepositorio.inserirPergunta(_pergunta);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Pergunta salva com sucesso');
    } else {
      _showAlertDialog('Status', 'Erro ao salvar pergunta');
    }
  }

  void _delete() async {
    _voltarParaUltimaTela();

    if (_pergunta.id == null) {
      _showAlertDialog('Status', 'Nenhuma pergunta foi apagada');
      return;
    }

    int result = await _perguntasRepositorio.apagarPergunta(_pergunta.id);
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

  void _logout(context) async {
    Login.registrarLogout();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

}