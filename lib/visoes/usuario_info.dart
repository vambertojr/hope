import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/repositorio_usuario.dart';
import 'package:hope/visoes/homepage.dart';

class UsuarioInfo extends StatefulWidget {

  final String appBarTitle;
  final Usuario usuario;

  UsuarioInfo(this.usuario, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return UsuarioInfoState(this.usuario, this.appBarTitle);
  }

}

class UsuarioInfoState extends State<UsuarioInfo> {

  GlobalKey<FormState> _formKey;

  RepositorioUsuario _repositorioUsuarios;

  String appBarTitle;
  Usuario usuario;

  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  String _papel;

  TextStyle textStyle;

  UsuarioInfoState(this.usuario, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _repositorioUsuarios = RepositorioUsuario();
    _loginController = new TextEditingController(text: usuario.login);
    _senhaController = new TextEditingController(text: usuario.senha);
    if(usuario.papel.isEmpty){
      usuario.papel = 'Médico';
    }
    _papel = usuario.papel;
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
            title: Text(appBarTitle),
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
                  _logout();
                },
                icon: Icon(Icons.logout),
              )
            ],
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _configurarLogin(),
                  _configurarSenha(),
                  _configurarSelecaoPapel(),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        _configurarBotaoSalvar(),
                        Container(width: 5.0,),
                        _configurarBotaoDeletar(context),
                      ],
                    ),
                  ),
                ],
              ),
          ),),

        ));
  }

  _configurarLogin(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _loginController,
        validator: _validarLogin,
        style: textStyle,
        onChanged: (value) {
          _atualizarLogin();
        },
        decoration: InputDecoration(
            labelText: 'Login',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );
  }

  _configurarSenha(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _senhaController,
        validator: _validarSenha,
        obscureText: true,
        style: textStyle,
        onChanged: (value) {
          _atualizarSenha();
        },
        decoration: InputDecoration(
            labelText: 'Senha',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
      ),
    );
  }

  _configurarSelecaoPapel(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: DropdownButtonFormField<String>(
        value: _papel,
        onChanged: (value) {
          _papel = value;
          _atualizarPapel();
        },
        decoration: InputDecoration(
            labelText: 'Papel',
            labelStyle: textStyle,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0)
            )
        ),
        items: <String>['Médico', 'Estudante']
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

  _configurarBotaoDeletar(context){
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
            _dialogoConfirmacaoExclusaoUsuario();
          });
        },
      ),
    );
  }

  _voltarParaUltimaTela() {
    Navigator.pop(context, true);
  }

  void _atualizarLogin(){
    usuario.login = _loginController.text;
  }

  void _atualizarSenha() {
    usuario.senha = _senhaController.text;
  }

  void _atualizarPapel(){
    usuario.papel = _papel;
  }

  void _dialogoConfirmacaoExclusaoUsuario(){
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
        content: Text('Você tem certeza que deseja apagar sua conta?'),
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
    if (usuario.id == null) {
      _voltarParaUltimaTela();
      _exibirDialogoAlerta('Status', 'Nenhum usuário foi apagado');
      return;
    }

    usuario.ativo = false;
    int resultado = await _repositorioUsuarios.atualizarUsuario(usuario);

    if (resultado != 0) {
      _logout();
      _exibirDialogoAlerta('Status', 'Usuário apagado com sucesso');
    } else {
      _voltarParaUltimaTela();
      _exibirDialogoAlerta('Status', 'Erro ao apagar usuário');
    }
  }

  void _salvar() async {
    int resultado;

    if (!_formKey.currentState.validate()) {
      return;
    }

    if (usuario.id != null) {
      resultado = await _repositorioUsuarios.atualizarUsuario(usuario);
    } else {
      resultado = await _repositorioUsuarios.inserirUsuario(usuario);
    }

    if (resultado != 0) {
      _voltarParaUltimaTela();
      _exibirDialogoAlerta('Status', 'Usuário salvo com sucesso');
    } else {
      bool existe = await _repositorioUsuarios.existeUsuarioAtivoComLogin(usuario);
      if(existe){
        _exibirDialogoAlerta('Status', 'Já existe um usuário com esse login');
      } else {
        _voltarParaUltimaTela();
        _exibirDialogoAlerta('Status', 'Erro ao salvar usuário');
      }
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

  String _validarLogin(String login){
    String mensagem;
    if(login.isEmpty){
      mensagem = "Informe o login";
    } else if(login.length<4){
      mensagem = "O login deve ter pelo menos 4 caracteres";
    }
    return mensagem;
  }

  String _validarSenha(String senha){
    String mensagem;
    if(senha.isEmpty){
      mensagem = "Informe a senha";
    } else if(senha.length<8){
      mensagem = "A senha deve ter pelo menos 8 caracteres";
    }
    return mensagem;
  }

  void _logout() async {
    Login.registrarLogout();
    await Navigator.of(context).pushNamed('home');
  }

}
