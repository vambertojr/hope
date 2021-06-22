import 'package:flutter/material.dart';
import 'package:hope/controladores/doenca_info_controller.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/login.dart';
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

  DoencaInfoController _doencaInfoController;

  String _appBarTitle;
  Doenca _doenca;

  TextEditingController _nomeController;
  TextEditingController _descricaoController;
  String _agenteController;

  DoencaInfoState(this._doenca, this._appBarTitle);

  GlobalKey<FormState> _formKey;

  TextStyle textStyle;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _descricaoController = TextEditingController();
    _nomeController.text = _doenca.nome;
    _descricaoController.text = _doenca.descricao;
    _agenteController = _doenca.agenteEtiologico.isEmpty ? 'Vírus' : _doenca.agenteEtiologico;
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {

    textStyle = Theme.of(context).textTheme.headline6;

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
            child: Form(
              key: _formKey,
              child:  ListView(
                children: <Widget>[
                  _configurarNome(),
                  _configurarDescricao(),
                  _configurarAgente(),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        _configurarBotaoSalvar(),
                        Container(width: 5.0,),
                        _configurarBotaoDeletar(),
                      ],
                    ),
                  ),
                ],
              ),
          )
          ),

        ));
  }

  _configurarNome(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _nomeController,
        validator: _doencaInfoController.validarNome,
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
    );
  }

  _configurarDescricao(){
    return Padding(
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
    );
  }

  _configurarAgente(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: _agenteController,
        onChanged: (value) {
          _agenteController = value;
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
    );
  }

  _configurarBotaoSalvar(){
    return Expanded(
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
            _salvar();
          });
        },
      ),
    );
  }

  _configurarBotaoDeletar(){
    return Expanded(
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
            if (_doenca.id == null) {
              _voltarParaUltimaTela();
              _exibirDialogoAlerta('Status', 'Nenhuma doença foi apagada');
              return;
            } else {
              _dialogoConfirmacaoExclusaoDoenca();
            }
          });
        },
      ),
    );
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
    _doenca.agenteEtiologico = _agenteController;
  }

  void _salvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _voltarParaUltimaTela();

    int resultado = await _doencaInfoController.salvar(_doenca);

    if (resultado != 0) {
      _exibirDialogoAlerta('Status', 'Doença salva com sucesso');
    } else {
      _exibirDialogoAlerta('Status', 'Erro ao salvar doença');
    }
  }

  void _dialogoConfirmacaoExclusaoDoenca(){
    Widget botaoCancelar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Cancelar"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    Widget botaoContinuar = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Continuar"),
      onPressed:  () {
        _apagar();
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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _apagar() async {
    int resultado = await _doencaInfoController.apagar(_doenca);

    _voltarParaUltimaTela();
    _voltarParaUltimaTela();

    if (resultado != 0) {
      _exibirDialogoAlerta('Status', 'Doença apagada com sucesso');
    } else {
      _exibirDialogoAlerta('Status', 'Erro ao apagar doença');
    }
  }

  void _exibirDialogoAlerta(String titulo, String mensagem) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
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