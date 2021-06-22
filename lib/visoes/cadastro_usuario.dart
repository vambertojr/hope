import 'package:flutter/material.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/usuario_repositorio.dart';
import 'package:hope/visoes/homepage.dart';

class CadastroUsuario extends StatefulWidget {

  final String appBarTitle;
  final Usuario usuario;

  CadastroUsuario(this.usuario, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return CadastroUsuarioState(this.usuario, this.appBarTitle);
  }

}

class CadastroUsuarioState extends State<CadastroUsuario> {

  GlobalKey<FormState> _formKey;

  UsuarioRepositorio _usuarioRepositorio;

  String appBarTitle;
  Usuario usuario;

  TextEditingController _loginController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  String _papel;

  CadastroUsuarioState(this.usuario, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _usuarioRepositorio = UsuarioRepositorio();
    _loginController = new TextEditingController(text: usuario.login);
    _senhaController = new TextEditingController(text: usuario.senha);
    if(usuario.papel.isEmpty){
      usuario.papel = 'Médico';
    }
    _papel = usuario.papel;
  }

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.headline6;

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
              child: ListView(
                children: <Widget>[

                  Padding(
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
                  ),

                  Padding(
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
                  ),

                  Padding(
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
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
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
                                _save();
                              });
                            },
                          ),
                        ),

                        Container(width: 5.0,),

                      ],
                    ),
                  ),


                ],
              ),
          ),),

        ));
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

  void _save() async {
    int result;

    if (!_formKey.currentState.validate()) {
      return;
    }

    if (usuario.id != null) {
      result = await _usuarioRepositorio.atualizarUsuario(usuario);
      Login.registrarLogout();
    } else {
      result = await _usuarioRepositorio.inserirUsuario(usuario);
    }

    if (result != 0) {
      _voltarParaUltimaTela();
      _showAlertDialog('Status', 'Usuário salvo com sucesso');
    } else {
      bool existe = await _usuarioRepositorio.existeUsuarioComLogin(usuario);
      if(existe){
        _showAlertDialog('Status', 'Já existe um usuário com esse login');
      } else {
        _showAlertDialog('Status', 'Erro ao salvar usuário');
      }
    }

  }

  void _showAlertDialog(String title, String message) {
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

  void _logout(context) async {
    Login.registrarLogout();
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

}
