import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';

class TelaInformacaoDoenca extends StatefulWidget {

  final String tituloAppBar;
  final Doenca doenca;

  TelaInformacaoDoenca(this.doenca, this.tituloAppBar);

  @override
  State<StatefulWidget> createState() {
    return TelaInformacaoDoencaState(this.doenca, this.tituloAppBar);
  }
}

class TelaInformacaoDoencaState extends State<TelaInformacaoDoenca> {

  ComponentesUtil _gerenciadorComponentes;
  String _tituloAppBar;
  Doenca _doenca;
  TextEditingController _tecNome;
  TextEditingController _tecDescricao;
  TextEditingController _tecAgente;
  TelaInformacaoDoencaState(this._doenca, this._tituloAppBar);
  TextStyle textStyle;

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    _tecNome = TextEditingController(text: _doenca.nome);
    _tecDescricao = TextEditingController(text: _doenca.descricao);
    _tecAgente = TextEditingController(text: _doenca.agenteEtiologico);
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
              child:  ListView(
                children: <Widget>[
                  _configurarNome(),
                  _configurarDescricao(),
                  _configurarAgente(),
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
        style: textStyle,
        enabled: false,
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
        controller: _tecDescricao,
        enabled: false,
        style: textStyle,
        minLines: 10,
        maxLines: 20,
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
      child: TextField(
        controller: _tecAgente,
        style: textStyle,
        enabled: false,
        decoration: InputDecoration(
            labelText: 'Agente etiológico',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );
  }

}