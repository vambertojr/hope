import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/repositorios/doenca_repositorio.dart';
import 'package:hope/visoes/homepage.dart';

class DoencaInfo extends StatefulWidget {

  final String appBarTitle;
  final Doenca doenca;

  DoencaInfo(this.doenca, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return DoencaInfoState(this.doenca, this.appBarTitle);
  }
}

class DoencaInfoState extends State<DoencaInfo> {

  DoencaRepositorio _helper;

  String _appBarTitle;
  Doenca _doenca;

  TextEditingController _nomeController;
  TextEditingController _descricaoController;
  String agenteController;

  DoencaInfoState(this._doenca, this._appBarTitle);

  @override
  void initState() {
    super.initState();
    _helper = DoencaRepositorio();
    _nomeController = TextEditingController();
    _descricaoController = TextEditingController();
    _nomeController.text = _doenca.nome;
    _descricaoController.text = _doenca.descricao;
    agenteController = _doenca.agenteEtiologico.isEmpty ? 'Vírus' : _doenca.agenteEtiologico;
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
                  child: TextField(
                    controller: _nomeController,
                    style: textStyle,
                    onChanged: (value) {
                      _atualizarNome();
                    },
                    decoration: InputDecoration(
                        labelText: 'Nome',
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
                    controller: _descricaoController,
                    style: textStyle,
                    minLines: 10,
                    maxLines: 20,
                    onChanged: (value) {
                      _atualizarDescricao();
                    },
                    decoration: InputDecoration(
                        labelText: 'Descrição',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: DropdownButtonFormField<String>(
                    value: agenteController,
                    onChanged: (value) {
                      agenteController = value;
                      _atualizarAgente();
                    },
                    decoration: InputDecoration(
                        labelText: 'Agente etiológico',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    items: <String>['Vírus', 'Bactéria', 'Fungo', 'Protozoário', 'Outros']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
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

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  void _atualizarNome(){
    _doenca.nome = _nomeController.text;
  }

  void _atualizarDescricao() {
    _doenca.descricao = _descricaoController.text;
  }

  void _atualizarAgente(){
    _doenca.agenteEtiologico = agenteController;
  }

  // Save data to database
  void _save() async {
    _voltarParaUltimaTela();

    int result;
    if (_doenca.id != null) {
      result = await _helper.atualizarDoenca(_doenca);
    } else {
      result = await _helper.inserirDoenca(_doenca);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Doença salva com sucesso');
    } else {  // Failure
      _showAlertDialog('Status', 'Erro ao salvar doença');
    }
  }

  void _delete() async {
    _voltarParaUltimaTela();

    if (_doenca.id == null) {
      _showAlertDialog('Status', 'Nenhuma doença foi apagada');
      return;
    }

    int result = await _helper.apagarDoenca(_doenca.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Doença apagada com sucesso');
    } else {
      _showAlertDialog('Status', 'Erro ao apagar doença');
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