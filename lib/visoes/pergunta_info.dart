import 'package:flutter/material.dart';
import 'package:hope/controladores/pergunta_info_controller.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
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

  PerguntaInfoController _perguntaInfoController;
  RepositorioDoenca _repositorioDoencas;

  String _appBarTitle;
  Pergunta _pergunta;
  List<Doenca> _doencasLista;
  Doenca _doencaSelecionada;
  int _gabarito;
  List<DropdownMenuItem<Doenca>> _menuDoencas;
  int _numeroAlternativas;

  TextEditingController _textoController;
  TextEditingController _alternativa1Controller;
  TextEditingController _alternativa2Controller;
  TextEditingController _alternativa3Controller;
  TextEditingController _alternativa4Controller;
  TextEditingController _alternativa5Controller;

  GlobalKey<FormState> _formKey;

  TextStyle textStyle;

  PerguntaInfoState(this._pergunta, this._appBarTitle);

  @override
  void initState() {
    super.initState();
    _perguntaInfoController = PerguntaInfoController();
    _repositorioDoencas = RepositorioDoenca();
    _textoController = new TextEditingController(text: _pergunta.texto);
    _alternativa1Controller = new TextEditingController(text: _pergunta.alternativa1);
    _alternativa2Controller = new TextEditingController(text: _pergunta.alternativa2);
    _alternativa3Controller = new TextEditingController(text: _pergunta.alternativa3);
    _alternativa4Controller = new TextEditingController(text: _pergunta.alternativa4);
    _alternativa5Controller = new TextEditingController(text: _pergunta.alternativa5);
    _gabarito = _pergunta.gabarito.toString().isEmpty ? 1 : _pergunta.gabarito;
    _inicializarMenuDoencas();
    _inicializarNumeroAlternativas();
    _formKey = GlobalKey<FormState>();
  }

  void _inicializarNumeroAlternativas(){
    int alternativasNull = 0;
    List<String> alternativas = [_pergunta.alternativa1, _pergunta.alternativa2,
      _pergunta.alternativa3, _pergunta.alternativa4, _pergunta.alternativa5];

    for(int i=0; i<alternativas.length; i++){
      if(alternativas[i] == null) alternativasNull++;
    }

    _numeroAlternativas = 5 - alternativasNull;
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
                children: configurarBody(),
              ),
            )
          ),

        ));
  }

  _configurarSelecaoDoenca(){
    return Padding(
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
    );
  }

  _configurarTexto(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _textoController,
        validator: _perguntaInfoController.validarTexto,
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
    );
  }

  _configurarAlternativa(int indice, TextEditingController controller, validator){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: textStyle,
        onChanged: (value) {
          _atualizarAlternativa(indice, controller);
        },
        decoration: InputDecoration(
            labelText: 'Alternativa $indice',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );
  }

  List<Widget> configurarBody(){
    var componentesParte1 = <Widget>[
      _configurarSelecaoDoenca(),
      _configurarTexto(),
      _configurarAlternativa(1, _alternativa1Controller,  _perguntaInfoController.validarAlternativa),
      _configurarAlternativa(2, _alternativa2Controller,  _perguntaInfoController.validarAlternativa)
    ];

    if(_numeroAlternativas>=4){
      componentesParte1.add(
          _configurarAlternativa(3, _alternativa3Controller,  _perguntaInfoController.validarAlternativa)
      );
      componentesParte1.add(
          _configurarAlternativa(4, _alternativa4Controller,  _perguntaInfoController.validarAlternativa)
      );
    }

    if(_numeroAlternativas==5){
      componentesParte1.add(
          _configurarAlternativa(5, _alternativa5Controller,  _perguntaInfoController.validarAlternativa)
      );
    }

    var componentesParte2 = <Widget>[
      _configurarSelecaoGabarito(),
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
    ];

    return componentesParte1+componentesParte2;
  }

  _configurarSelecaoGabarito(){
    List<int> opcoesGabarito = [1, 2, 3, 4, 5];
    if(_numeroAlternativas==2) opcoesGabarito = [1, 2];
    if(_numeroAlternativas==4) opcoesGabarito = [1, 2, 3, 4];

    return Padding(
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
        items: opcoesGabarito
            .map<DropdownMenuItem<int>>((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
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
            if (_pergunta.id == null) {
              _voltarParaUltimaTela();
              _exibirDialogoAlerta('Status', 'Nenhuma pergunta foi apagada');
              return;
            } else {
              _dialogoConfirmacaoExclusaoPergunta();
            }
          });
        },
      ),
    );
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
      Future<List<Doenca>> listaDoencasFutura = _repositorioDoencas.getListaDoencasAtivas();
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

  void _salvar() async {

    if (!_formKey.currentState.validate()) {
      return;
    }

    _voltarParaUltimaTela();

    int resultado = await _perguntaInfoController.salvar(_pergunta);

    if (resultado != 0) {
      _exibirDialogoAlerta('Status', 'Pergunta salva com sucesso');
    } else {
      _exibirDialogoAlerta('Status', 'Erro ao salvar pergunta');
    }
  }

  void _dialogoConfirmacaoExclusaoPergunta(){
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
      content: Text('Você tem certeza que deseja apagar a pergunta?'),
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
    int resultado = await _perguntaInfoController.apagar(_pergunta);

    _voltarParaUltimaTela();
    _voltarParaUltimaTela();

    if (resultado != 0) {
      _exibirDialogoAlerta('Status', 'Pergunta foi apagada com sucesso');
    } else {
      _exibirDialogoAlerta('Status', 'Erro ao apagar pergunta');
    }
  }

  void _exibirDialogoAlerta(String title, String message) {
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