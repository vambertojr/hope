import 'package:flutter/material.dart';
import 'package:hope/controladores/quiz_controller.dart';
import 'package:hope/modelos/doenca.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/repositorios/repositorio_doenca.dart';
import 'package:hope/repositorios/repositorio_quiz.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';
import 'package:hope/visoes/componentes/dialogo_alerta.dart';
import 'package:hope/visoes/componentes/dialogo_alerta_confirmacao.dart';
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

  ComponentesUtil _gerenciadorComponentes;
  RepositorioDoenca _doencasRepositorio;
  RepositorioQuiz _quizRepositorio;
  String _tituloAppBar;
  Quiz _quiz;
  List<Doenca> _doencasLista;
  Doenca _doencaSelecionada;
  List<DropdownMenuItem<Doenca>> _menuDoencas;
  TextEditingController _tecQuantidadePerguntas;
  TextEditingController _tecTitulo;
  TextStyle textStyle;
  GlobalKey<FormState> _formKey;

  TelaCadastroQuizState(this._quiz, this._tituloAppBar);

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = ComponentesUtil();
    _doencasRepositorio = RepositorioDoenca();
    _quizRepositorio = RepositorioQuiz();
    _tecQuantidadePerguntas = new TextEditingController(text: _quiz.totalPerguntas.toString());
    _tecTitulo = new TextEditingController(text: _quiz.titulo);
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
          appBar: _gerenciadorComponentes.appBar(_tituloAppBar, context),

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
        controller: _tecTitulo,
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
        controller: _tecQuantidadePerguntas,
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
    _quiz.titulo = this._tecTitulo.text;
  }

  void _atualizarDoenca(Doenca doenca){
    _doencaSelecionada = doenca;
    _quiz.doenca = _doencaSelecionada;
  }

  void _atualizarQuantidadePerguntas() {
    if(this._tecQuantidadePerguntas.text == null || this._tecQuantidadePerguntas.text.isEmpty){
      _quiz.totalPerguntas = 0;
    } else {
      _quiz.totalPerguntas = int.parse(this._tecQuantidadePerguntas.text);
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
        DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Quiz atualizado com sucesso');
      } else {
        DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Erro ao atualizar quiz');
      }
    } else {
      QuizController quizController = QuizController(_quiz);
      int resultado = await quizController.sortearPerguntas();

      if(resultado == 0){ //não gerou quiz
        Navigator.pop(context, true);
        DialogoAlerta.show(context, titulo: 'Aviso',
            mensagem: 'Não é possível gerar quiz porque não há perguntas cadastradas');
      } else if(resultado == 1){ //gerou sem alerta
        _navegarParaTelaResponderQuiz();
      } else if(resultado == 2){ //gerou com alerta
        String mensagem = 'Não há perguntas cadastradas suficientes. O quiz será '
            'gerado com as perguntas existentes';
        DialogoAlertaConfirmacao.show(context, titulo: 'Aviso', mensagem: mensagem,
            confirmar: _navegarParaTelaResponderQuiz);
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

}