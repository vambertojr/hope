import 'package:flutter/material.dart';
import 'package:hope/controladores/doenca_controller.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/visoes/componentes/dialogo_alerta.dart';
import 'package:hope/visoes/componentes/dialogo_confirmacao_exclusao.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';

class TelaCadastroDoenca extends StatefulWidget {

  final String tituloAppBar;
  final Doenca doenca;

  TelaCadastroDoenca(this.doenca, this.tituloAppBar);

  @override
  State<StatefulWidget> createState() {
    return TelaCadastroDoencaState(this.doenca, this.tituloAppBar);
  }
}

class TelaCadastroDoencaState extends State<TelaCadastroDoenca> {

  ComponentesUtil _gerenciadorComponentes;
  String _tituloAppBar;
  Doenca _doenca;
  TextEditingController _tecNome;
  TextEditingController _tecDescricao;
  String _tecAgente;
  TelaCadastroDoencaState(this._doenca, this._tituloAppBar);
  GlobalKey<FormState> _formKey;
  TextStyle textStyle;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    _tecNome = TextEditingController();
    _tecDescricao = TextEditingController();
    _tecNome.text = _doenca.nome;
    _tecDescricao.text = _doenca.descricao;
    if(_doenca.agenteEtiologico.isEmpty){
      _tecAgente = 'Vírus';
      _doenca.agenteEtiologico = _tecAgente;
    } else {
      _tecAgente = _doenca.agenteEtiologico;
    }
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    textStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(

        onWillPop: () {
          return _gerenciadorComponentes.voltarParaUltimaTela(context);
        },

        child: Scaffold(
          appBar: _gerenciadorComponentes.appBar(_tituloAppBar, context),

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
        controller: _tecNome,
        validator: _validarNome,
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

  String _validarNome(String nome){
    String mensagem;
    if(nome.isEmpty){
      mensagem = "Informe o nome da doença";
    }
    return mensagem;
  }

  _configurarDescricao(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextField(
        controller: _tecDescricao,
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
        value: _tecAgente,
        onChanged: (value) {
          _tecAgente = value;
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
              Navigator.pop(context, true);
              DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Nenhuma doença foi apagada');
              return;
            } else {
              String mensagem = 'Você tem certeza que deseja apagar a doença? Perguntas que a utilizam também serão apagadas.';
              DialogoConfirmacaoExclusao.show(context, mensagem: mensagem, apagar: _apagar);
            }
          });
        },
      ),
    );
  }

  void _atualizarNome(){
    _doenca.nome = _tecNome.text;
  }

  void _atualizarDescricao() {
    _doenca.descricao = _tecDescricao.text;
  }

  void _atualizarAgente(){
    _doenca.agenteEtiologico = _tecAgente;
  }

  void _salvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    DoencaController doencaController = DoencaController(_doenca);
    int resultado = await doencaController.salvar();

    if(resultado == -1){
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Já existe uma doença com esse nome');
    } else if(resultado == 0){
      Navigator.pop(context, true);
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Erro ao salvar doença');
    } else {
      Navigator.pop(context, true);
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Doença salva com sucesso');
    }
  }

  void _apagar() async {
    DoencaController doencaController = DoencaController(_doenca);
    int resultado = await doencaController.apagar();

    Navigator.pop(context, true);
    Navigator.pop(context, true);

    if (resultado != 0) {
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Doença apagada com sucesso');
    } else {
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Erro ao apagar doença');
    }
  }

}