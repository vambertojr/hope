import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/pergunta.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/modelos/resposta.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
import 'package:hope/repositorios/repositorio_pergunta.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';
import 'package:hope/visoes/componentes/gerenciador_componentes.dart';
import 'package:hope/visoes/tela_responder_quiz.dart';


class TelaCadastroQuiz extends StatefulWidget {

  final String tituloAppBar;
  final Quiz quiz;

  TelaCadastroQuiz(this.quiz, this.tituloAppBar);

  @override
  State<StatefulWidget> createState() {
    return TelaCadastroQuizState(this.quiz, this.tituloAppBar);
  }
}

class TelaCadastroQuizState extends State<TelaCadastroQuiz> {
  GerenciadorComponentes _gerenciadorComponentes;
  RepositorioPergunta _perguntasRepositorio;
  RepositorioDoenca _doencasRepositorio;
  RepositorioQuiz _quizRepositorio;
  String _tituloAppBar;
  Quiz _quiz;
  List<Doenca> _doencasLista;
  Doenca _doencaSelecionada;
  List<DropdownMenuItem<Doenca>> _menuDoencas;
  TextEditingController _quantidadePerguntasController;
  TextEditingController _tituloController;
  TextStyle textStyle;
  GlobalKey<FormState> _formKey;

  TelaCadastroQuizState(this._quiz, this._tituloAppBar);

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = GerenciadorComponentes();
    _perguntasRepositorio = RepositorioPergunta();
    _doencasRepositorio = RepositorioDoenca();
    _quizRepositorio = RepositorioQuiz();
    _quantidadePerguntasController = new TextEditingController(text: _quiz.totalPerguntas.toString());
    _tituloController = new TextEditingController(text: _quiz.titulo);
    _inicializarMenuDoencas();
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
          appBar: _gerenciadorComponentes.configurarAppBar(_tituloAppBar, context),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(
              key: _formKey,
              child:  ListView(
                  children: <Widget>[
                    _configurarExibicaoTitulo(),
                    _configurarExibicaoDoenca(),
                    _configurarNumeroPerguntas(),
                    _configurarBotaoCriar(context),
                  ],
                )
            ),
          ),

        ));
  }

  _configurarExibicaoTitulo(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _tituloController,
        validator: _validarTitulo,
        style: textStyle,
        onChanged: (value) {
          _atualizarTitulo();
        },
        decoration: InputDecoration(
            labelText: 'Título',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );
  }

  _configurarExibicaoDoenca(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: DropdownButtonFormField<Doenca>(
        value: _doencaSelecionada,
        onChanged: (doenca) {
          setState(() {
            _atualizarDoenca(doenca);
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

  _configurarNumeroPerguntas(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _quantidadePerguntasController,
        validator: _validarQuantidadePerguntas,
        style: textStyle,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          _atualizarQuantidadePerguntas();
        },
        decoration: InputDecoration(
            labelText: 'Quantidade de perguntas',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );
  }

  _configurarBotaoCriar(BuildContext contexto){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            // ignore: deprecated_member_use
            child: RaisedButton(
              color: Colors.teal,
              textColor: Colors.white,
              child: Text(
                'Criar',
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  _criarQuiz();
                });
              },
            ),
          ),

          Container(width: 5.0,),

        ],
      ),
    );
  }

  String _validarTitulo(String titulo){
    String mensagem;
    if(titulo.isEmpty){
      mensagem = "Informe o título";
    }
    return mensagem;
  }

  String _validarQuantidadePerguntas(String quantidade){
    String mensagem;
    if(quantidade.isEmpty){
      mensagem = "Informe a quantidade de perguntas";
    }
    return mensagem;
  }

  void _atualizarDoencasLista(){
    _menuDoencas = _doencasLista.map((doenca) => DropdownMenuItem<Doenca>(
      child: Text(doenca.nome),
      value: doenca,
    )
    ).toList();
  }

  void _inicializarMenuDoencas() async {
      this._doencasLista = [new Doenca('Nenhuma doença específica', '', '')];
      Future<List<Doenca>> listaDoencasFutura = _doencasRepositorio.getListaDoencasAtivas();
      listaDoencasFutura.then((listaDoencas) {
        setState(() {
          this._doencasLista += listaDoencas;
          _atualizarDoencasLista();
          _inicializarDoencaSelecionada();
        });
      });
  }

  void _inicializarDoencaSelecionada(){
    if(_quiz.doenca == null || _quiz.doenca.nome.isEmpty){
      _quiz.doenca = this._doencasLista[0];
    }
    this._doencaSelecionada = _quiz.doenca;
  }

  void _atualizarTitulo() {
    _quiz.titulo = this._tituloController.text;
  }

  void _atualizarDoenca(Doenca doenca){
    _doencaSelecionada = doenca;
    _quiz.doenca = _doencaSelecionada;
  }

  void _atualizarQuantidadePerguntas() {
    if(this._quantidadePerguntasController.text == null || this._quantidadePerguntasController.text.isEmpty){
      _quiz.totalPerguntas = 0;
    } else {
      _quiz.totalPerguntas = int.parse(this._quantidadePerguntasController.text);
    }
  }

  void _criarQuiz() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    int result;
    if (_quiz.id != null) {
      result = await _quizRepositorio.atualizarQuiz(_quiz);
      Navigator.pop(context, true);
      if (result != 0) {
        _gerenciadorComponentes.exibirDialogoAlerta('Status',
            'Quiz atualizado com sucesso', context);
      } else {
        _gerenciadorComponentes.exibirDialogoAlerta('Status',
            'Erro ao atualizar quiz', context);
      }
    } else {
      int resultado = await _sortearPerguntas(context);
      if(resultado == 0){ //não gerou quiz
        Navigator.pop(context, true);
        _gerenciadorComponentes.exibirDialogoAlerta('Status',
            'Não é possível gerar quiz porque não há perguntas cadastradas.', context);
      } else if(resultado == 1){ //gerou sem alerta
        _navegarParaTelaResponderQuiz();
      } else if(resultado == 2){ //gerou com alerta
        _exibirDialogoAlertaComBotao();
      }
    }
  }

  _navegarParaTelaResponderQuiz(){
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      String mensagem = '${_quiz.titulo} (${_quiz.totalPerguntas} perguntas)';
      if(_quiz.totalPerguntas==1) mensagem = '${_quiz.titulo} (${_quiz.totalPerguntas} pergunta)';
      return TelaResponderQuiz(_quiz, mensagem);
    }));
  }

  List _embaralhar(List<Pergunta> itens) {
    Random random = new Random();
    for (int i=itens.length-1; i>0; i--) {
      int n = random.nextInt(i+1);
      Pergunta temp = itens[i];
      itens[i] = itens[n];
      itens[n] = temp;
    }
    return itens;
  }

  List<Resposta> _converterParaListaRespostas(List perguntas){
    List<Resposta> respostas = [];
    for (int i=0; i<perguntas.length; i++) {
      respostas.add(new Resposta(0, perguntas[i]));
    }
    return respostas;
  }

  Future<int> _sortearPerguntas(BuildContext contexto) async {
    int resultado = 1; //0 - nao gerou, 1 - gerou sem alerta, 2 - gerou com alerta
    List<Pergunta> todasAsPerguntas;
    if(_quiz.doenca.id != null){
      todasAsPerguntas = await _perguntasRepositorio.getListaPerguntasAtivasPorDoenca(_quiz.doenca);
    } else {
      todasAsPerguntas = await _perguntasRepositorio.getListaPerguntasAtivas();
    }

    if(todasAsPerguntas==null || todasAsPerguntas.isEmpty){
      resultado = 0;
    } else if(todasAsPerguntas.length<_quiz.totalPerguntas){
      _quiz.perguntas = _converterParaListaRespostas(_embaralhar(todasAsPerguntas));
      _quiz.totalPerguntas = _quiz.perguntas.length;
      resultado = 2;
    } else if(todasAsPerguntas.length==_quiz.totalPerguntas){
      _quiz.perguntas = _converterParaListaRespostas(_embaralhar(todasAsPerguntas));
    } else {
      Random random = new Random();
      _quiz.perguntas = [];
      while(_quiz.perguntas.length<_quiz.totalPerguntas){
        int indice = random.nextInt(todasAsPerguntas.length);
        Pergunta pergunta = todasAsPerguntas[indice];
        if(!_perguntaJaFoiSelecionada(pergunta)){
          _quiz.perguntas.add(new Resposta(0, pergunta));
        }
      }
    }
    return resultado;
  }

  void _exibirDialogoAlertaComBotao() async {
    String titulo = 'Status';
    String mensagem = 'Não há perguntas cadastradas suficientes. O quiz será '
        'gerado com as perguntas existentes';

    Widget botaoOk = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
        _navegarParaTelaResponderQuiz();
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      backgroundColor: Colors.white,
      actions: [
        botaoOk,
      ],
    );

    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  bool _perguntaJaFoiSelecionada(Pergunta perguntaDeInteresse){
    List<Pergunta> perguntas = [];
    for(int i=0; i<_quiz.perguntas.length; i++){
      perguntas.add(_quiz.perguntas[i].pergunta);
    }
    return perguntas.contains(perguntaDeInteresse);
  }

}