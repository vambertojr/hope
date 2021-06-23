import 'package:flutter/material.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/repositorio_usuario.dart';
import 'package:hope/visoes/componentes/gerenciador_componentes.dart';

class TelaCadastroUsuario extends StatefulWidget {

  final String tituloAppBar;
  final Usuario usuario;

  TelaCadastroUsuario(this.usuario, this.tituloAppBar);

  @override
  State<StatefulWidget> createState() {
    return TelaCadastroUsuarioState(this.usuario, this.tituloAppBar);
  }

}

class TelaCadastroUsuarioState extends State<TelaCadastroUsuario> {

  GerenciadorComponentes _gerenciadorComponentes;
  GlobalKey<FormState> _formKey;
  RepositorioUsuario _repositorioUsuarios;
  String _tituloAppBar;
  TextEditingController _tecLogin;
  TextEditingController _tecSenha;
  TextStyle textStyle;
  String _papel;
  Usuario _usuario;

  TelaCadastroUsuarioState(this._usuario, this._tituloAppBar);

  @override
  void initState() {
    super.initState();
    _gerenciadorComponentes = GerenciadorComponentes();
    _formKey = GlobalKey<FormState>();
    _repositorioUsuarios = RepositorioUsuario();
    _tecLogin = new TextEditingController(text: _usuario.login);
    _tecSenha = new TextEditingController(text: _usuario.senha);
    if(_usuario.papel.isEmpty){
      _usuario.papel = 'Médico';
    }
    _papel = _usuario.papel;
  }

  @override
  Widget build(BuildContext contexto) {
    textStyle = Theme.of(contexto).textTheme.headline6;

    return WillPopScope(
        onWillPop: () {
          return _gerenciadorComponentes.voltarParaUltimaTela(contexto);
        },

        child: Scaffold(
          appBar: _gerenciadorComponentes.configurarAppBar(_tituloAppBar, contexto),

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
                        _configurarBotaoDeletar(contexto),
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
        controller: _tecLogin,
        validator: validarCadastroLogin,
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

  String validarCadastroLogin(String login){
    String mensagem;
    if(login.isEmpty){
      mensagem = "Informe o login";
    } else if(login.length<4){
      mensagem = "O login deve ter pelo menos 4 caracteres";
    }
    return mensagem;
  }

  String validarCadastroSenha(String senha){
    String mensagem;
    if(senha.isEmpty){
      mensagem = "Informe a senha";
    } else if(senha.length<8){
      mensagem = "A senha deve ter pelo menos 8 caracteres";
    }
    return mensagem;
  }

  _configurarSenha(){
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: _tecSenha,
        validator: validarCadastroSenha,
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

  void _atualizarLogin(){
    _usuario.login = _tecLogin.text;
  }

  void _atualizarSenha() {
    _usuario.senha = _tecSenha.text;
  }

  void _atualizarPapel(){
    _usuario.papel = _papel;
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
    if (_usuario.id == null) {
      _gerenciadorComponentes.voltarParaUltimaTela(context);
      _gerenciadorComponentes.exibirDialogoAlerta('Status', 'Nenhum usuário foi apagado', context);
      return;
    }

    _usuario.ativo = false;
    int resultado = await _repositorioUsuarios.atualizarUsuario(_usuario);

    if (resultado != 0) {
      _gerenciadorComponentes.logout(context);
      _gerenciadorComponentes.exibirDialogoAlerta('Status', 'Usuário apagado com sucesso', context);
    } else {
      _gerenciadorComponentes.voltarParaUltimaTela(context);
      _gerenciadorComponentes.exibirDialogoAlerta('Status', 'Erro ao apagar usuário', context);
    }
  }

  void _salvar() async {
    int resultado;

    if (!_formKey.currentState.validate()) {
      return;
    }

    if (_usuario.id != null) {
      resultado = await _repositorioUsuarios.atualizarUsuario(_usuario);
    } else {
      resultado = await _repositorioUsuarios.inserirUsuario(_usuario);
    }

    if (resultado != 0) {
      _gerenciadorComponentes.voltarParaUltimaTela(context);
      _gerenciadorComponentes.exibirDialogoAlerta('Status', 'Usuário salvo com sucesso', context);
    } else {
      bool existe = await _repositorioUsuarios.existeUsuarioAtivoComLogin(_usuario);
      if(existe){
        _gerenciadorComponentes.exibirDialogoAlerta('Status',
            'Já existe um usuário com esse login', context);
      } else {
        _gerenciadorComponentes.voltarParaUltimaTela(context);
        _gerenciadorComponentes.exibirDialogoAlerta('Status', 'Erro ao salvar usuário', context);
      }
    }

  }

}
