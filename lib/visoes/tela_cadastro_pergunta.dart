import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';
import 'package:hope/visoes/componentes/dialogo_alerta.dart';
import 'package:hope/visoes/componentes/dialogo_confirmacao_exclusao.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';


class TelaCadastroPergunta extends StatefulWidget {

  final String tituloAppBar;
  final Pergunta pergunta;

  TelaCadastroPergunta(this.pergunta, this.tituloAppBar);

  @override
  State<StatefulWidget> createState() {
    return TelaCadastroPerguntaState(this.pergunta, this.tituloAppBar);
  }
}

class TelaCadastroPerguntaState extends State<TelaCadastroPergunta> {
  ComponentesUtil _gerenciadorComponentes;
  RepositorioPergunta _repositorioPerguntas;
  RepositorioQuiz _repositorioQuiz;
  RepositorioDoenca _repositorioDoencas;
  String _tituloAppBar;
  Pergunta _pergunta;
  List<Doenca> _doencasLista;
  Doenca _doencaSelecionada;
  int _tecGabarito;
  List<DropdownMenuItem<Doenca>> _menuDoencas;
  int _numeroAlternativas;
  TextEditingController _tecTexto;
  TextEditingController _tecAlternativa1;
  TextEditingController _tecAlternativa2;
  TextEditingController _tecAlternativa3;
  TextEditingController _tecAlternativa4;
  TextEditingController _tecAlternativa5;
  GlobalKey<FormState> _formKey;
  TextStyle textStyle;

  TelaCadastroPerguntaState(this._pergunta, this._tituloAppBar);

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    _repositorioPerguntas = RepositorioPergunta();
    _repositorioQuiz = RepositorioQuiz();
    _repositorioDoencas = RepositorioDoenca();
    _tecTexto = new TextEditingController(text: _pergunta.texto);
    _tecAlternativa1 = new TextEditingController(text: _pergunta.alternativa1);
    _tecAlternativa2 = new TextEditingController(text: _pergunta.alternativa2);
    _tecAlternativa3 = new TextEditingController(text: _pergunta.alternativa3);
    _tecAlternativa4 = new TextEditingController(text: _pergunta.alternativa4);
    _tecAlternativa5 = new TextEditingController(text: _pergunta.alternativa5);
    _tecGabarito = _pergunta.gabarito.toString().isEmpty ? 1 : _pergunta.gabarito;
    _inicializarMenuDoencas();
    _inicializarNumeroAlternativas();
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
                children: configurarBody(),
              ),
            )
          ),

        ));
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

  String _validarTexto(String texto){
    String mensagem;
    if(texto.isEmpty){
      mensagem = "Informe o texto da pergunta";
    }
    return mensagem;
  }

  _configurarTexto(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _tecTexto,
        validator: _validarTexto,
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

  String _validarAlternativa(String alternativa){
    String mensagem;
    if(alternativa.isEmpty){
      mensagem = "Informe a alternativa";
    }
    return mensagem;
  }

  List<Widget> configurarBody(){
    var componentesParte1 = <Widget>[
      _configurarSelecaoDoenca(),
      _configurarTexto(),
      _configurarAlternativa(1, _tecAlternativa1,  _validarAlternativa),
      _configurarAlternativa(2, _tecAlternativa2,  _validarAlternativa)
    ];

    if(_numeroAlternativas>=4){
      componentesParte1.add(
          _configurarAlternativa(3, _tecAlternativa3,  _validarAlternativa)
      );
      componentesParte1.add(
          _configurarAlternativa(4, _tecAlternativa4,  _validarAlternativa)
      );
    }

    if(_numeroAlternativas==5){
      componentesParte1.add(
          _configurarAlternativa(5, _tecAlternativa5,  _validarAlternativa)
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
        value: _tecGabarito,
        onChanged: (value) {
          _tecGabarito = value;
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
              Navigator.pop(context, true);
              DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Nenhuma pergunta foi apagada');
              return;
            } else {
              String mensagem = 'Você tem certeza que deseja apagar a pergunta?';
              DialogoConfirmacaoExclusao.show(context, mensagem: mensagem, apagar: _apagar);
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

  void _atualizarTexto(){
    _pergunta.texto = _tecTexto.text;
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
    _pergunta.gabarito = _tecGabarito;
  }

  void _salvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Navigator.pop(context, true);

    int resultado;
    if (_pergunta.id != null) {
      resultado = await _repositorioPerguntas.atualizarPergunta(_pergunta);
    } else {
      resultado = await _repositorioPerguntas.inserirPergunta(_pergunta);
    }

    if (resultado != 0) {
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Pergunta salva com sucesso');
    } else {
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Erro ao salvar pergunta');
    }
  }

  void _apagar() async {
    int resultado;
    bool existeQuiz = await _repositorioQuiz.existeQuizQueUsaPergunta(_pergunta);

    if(existeQuiz){
      _pergunta.ativa = false;
      resultado = await _repositorioPerguntas.atualizarPergunta(_pergunta);
    } else {
      resultado = await _repositorioPerguntas.apagarPergunta(_pergunta.id);
    }

    Navigator.pop(context, true);
    Navigator.pop(context, true);

    if (resultado != 0) {
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Pergunta foi apagada com sucesso');
    } else {
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Erro ao apagar pergunta');
    }
  }

}