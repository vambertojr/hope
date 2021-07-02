import 'package:flutter/material.dart';
import 'package:hope/controladores/usuario_controller.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/visoes/componentes/dialogo_alerta.dart';
import 'package:hope/visoes/componentes/dialogo_confirmacao_exclusao.dart';
import 'package:hope/visoes/componentes/componentes_util.dart';

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

  ComponentesUtil _gerenciadorComponentes;
  GlobalKey<FormState> _formKey;
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
    _gerenciadorComponentes = ComponentesUtil();
    _formKey = GlobalKey<FormState>();
    _tecLogin = new TextEditingController(text: _usuario.login);
    _tecSenha = new TextEditingController(text: _usuario.senha);
    if(_usuario.papel.isEmpty){
      _usuario.papel = ComponentesUtil.papelAdmin;
    }
    _papel = _usuario.papel;
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
        controller: _tecLogin,
        validator: _validarCadastroLogin,
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

  String _validarCadastroLogin(String login){
    String mensagem;
    if(login.isEmpty){
      mensagem = "Informe o login";
    } else if(login.length<4){
      mensagem = "O login deve ter pelo menos 4 caracteres";
    }
    return mensagem;
  }

  String _validarCadastroSenha(String senha){
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
        validator: _validarCadastroSenha,
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
        items: <String>[ComponentesUtil.papelAdmin, ComponentesUtil.papelUsuario]
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
            String mensagem = 'Você tem certeza que deseja apagar sua conta?';
            DialogoConfirmacaoExclusao.show(context, mensagem: mensagem, apagar: _apagar);
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

  void _apagar() async {
    if (_usuario.id == null) {
      Navigator.pop(context, true);
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Nenhum usuário foi apagado');
      return;
    }

    UsuarioController usuarioController = UsuarioController(_usuario);
    int resultado = await usuarioController.apagar();

    if (resultado != 0) {
      _gerenciadorComponentes.logout(context);
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Usuário apagado com sucesso');
    } else {
      Navigator.pop(context, true);
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Erro ao apagar usuário');
    }
  }

  void _salvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    UsuarioController usuarioController = UsuarioController(_usuario);
    int resultado = await usuarioController.salvar();

    if(resultado == -1){
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Já existe um usuário com esse login');
    } else if(resultado == 0){
      Navigator.pop(context, true);
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Erro ao salvar usuário');
    } else {
      Navigator.pop(context, true);
      DialogoAlerta.show(context, titulo: 'Aviso', mensagem: 'Usuário salvo com sucesso');
    }

  }

}
