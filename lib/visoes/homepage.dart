import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/usuario_repositorio.dart';
import 'package:hope/visoes/cadastro_usuario.dart';
import 'package:hope/visoes/menu.dart';
import 'package:hope/visoes/menu_estudante.dart';


class HomePage extends StatelessWidget {

  final TextEditingController _tedLogin = TextEditingController();
  final TextEditingController _tedSenha = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle textStyle;
  UsuarioRepositorio _usuarioRepositorio = new UsuarioRepositorio();

  @override
  Widget build(BuildContext context) {
    textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: _body(context),
    );
  }

  _body(context) {
    return Form(
      key: _formKey,
      //height: double.infinity,
      //margin: EdgeInsets.only(top:12.0, bottom: 12.0, left: 12, right: 12),
      //color: Colors.white,
      child: ListView(
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _pageView(),
                _textFormFieldLogin(),
                SizedBox(height: 10),
                _textFormFieldSenha(),
                Container(
                height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _entrarButton(context),
                      _cadastrarButton(context)
                    ],
                  ),
                ),

              ]
          ),
      ],
    ));
  }

  Container _pageView() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      color: Colors.white,
      height: 150,
      child: PageView(
        children: <Widget>[
          Image.asset(
            "images/hope_logo.png",
            width: 10,
            height: 50,
          ),
        ],
      ),
    );
  }

  Container _textFormFieldLogin() {
    return Container(
        margin: EdgeInsets.only(top:12.0, bottom: 12.0, left: 12, right: 12),
        color: Colors.white,
        child: TextFormField(
          controller: _tedLogin,
          validator: _validarLogin,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: "Login",
              labelStyle: textStyle,
              hintText: "Informe o login"
          )
        )
    );
  }

  Container _textFormFieldSenha() {
    return Container(
        margin: EdgeInsets.only(top:12.0, bottom: 12.0, left: 12, right: 12),
        color: Colors.white,
        child: TextFormField(
          controller: _tedSenha,
          validator: _validarSenha,
          obscureText: true,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: textStyle,
              hintText: "Informe a senha"
          )
        )
    );
  }

  String _validarLogin(String text){
    if(text.isEmpty){
      return "Informe o login";
    }
    return null;
  }

  String _validarSenha(String text){
    if(text.isEmpty){
      return "Informe a senha";
    }
    return null;
  }

  _entrarButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Entrar"),
      onPressed: () {
          _onCliqueEntrar(context);
        },
    );
  }

  _onCliqueEntrar(BuildContext context) async {
    final login = _tedLogin.text;
    final senha = _tedSenha.text;

    print("Login: $login , Senha: $senha ");
    if (!_formKey.currentState.validate()) {
      return;
    }

    Usuario usuario = new Usuario(login, senha);
    var usuarioEncontrado = await _usuarioRepositorio.getUsuario(usuario);

    if(usuarioEncontrado == null) {
      _showAlertDialog('Status', 'Usuário não encontrado', context);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
        if(usuarioEncontrado.papel == 'Médico'){
          return Menu();
        } else {
          return MenuEstudante();
        }
      }));
    }

  }

  void _showAlertDialog(String title, String message, context) {
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

  _cadastrarButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Cadastrar"),
      onPressed: () {
        navigateToDetail(Usuario('', '', ''), 'Adicionar usuário', context);
      },
    );
  }

  void navigateToDetail(Usuario usuario, String titulo, context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CadastroUsuario(usuario, titulo);
    }));

  }

}
