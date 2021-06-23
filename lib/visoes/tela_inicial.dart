import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hope/controladores/login_controller.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/repositorios/repositorio_usuario.dart';
import 'package:hope/visoes/componentes/gerenciador_componentes.dart';
import 'package:hope/visoes/tela_cadastro_usuario.dart';
import 'package:hope/visoes/tela_menu.dart';
import 'package:hope/visoes/tela_menu_estudante.dart';

class TelaInicial extends StatelessWidget {

  final LoginController _loginController = LoginController();
  final TextEditingController _tecLogin = TextEditingController();
  final TextEditingController _tecSenha = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GerenciadorComponentes _gerenciadorComponentes = GerenciadorComponentes();
  final RepositorioUsuario _repositorioUsuarios = RepositorioUsuario();

  @override
  Widget build(BuildContext context) {
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
      child: ListView(
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top:12.0, bottom: 12.0, left: 12, right: 12),
                  color: Colors.white,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _configurarLogotipo(),
                        _configurarLogin(context),
                        SizedBox(height: 10),
                        _configurarSenha(context)
                      ],
                  ),
                ),

                Container(
                height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _configurarBotaoEntrar(context),
                      _configurarBotaoCadastrar(context)
                    ],
                  ),
                ),

              ]
          ),
      ],
    ));
  }

  Container _configurarLogotipo() {
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

  TextFormField _configurarLogin(BuildContext contexto) {
    return TextFormField(
          controller: _tecLogin,
          validator: validarLogin,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: "Login",
              labelStyle: Theme.of(contexto).textTheme.headline6,
              hintText: "Informe o login"
          )
    );
  }

  String validarLogin(String login){
    if(login.isEmpty){
      return "Informe o login";
    }
    return null;
  }

  TextFormField _configurarSenha(BuildContext contexto) {
    return TextFormField(
          controller: _tecSenha,
          validator: validarSenha,
          obscureText: true,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              labelText: "Senha",
              labelStyle: Theme.of(contexto).textTheme.headline6,
              hintText: "Informe a senha"
          )
        );
  }

  String validarSenha(String senha){
    if(senha.isEmpty){
      return "Informe a senha";
    }
    return null;
  }

  _configurarBotaoEntrar(BuildContext contexto) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Entrar"),
      onPressed: () {
          _entrar(contexto);
        },
    );
  }

  _entrar(BuildContext contexto) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Usuario usuario = new Usuario(_tecLogin.text, _tecSenha.text, '');
    Usuario usuarioEncontrado = await _repositorioUsuarios.getUsuario(usuario);

    if(usuarioEncontrado == null) {
      _gerenciadorComponentes.exibirDialogoAlerta('Status', 'Usuário não encontrado', contexto);
      return;
    }
    else {
      _loginController.registrarLogin(usuarioEncontrado);

      Navigator.push(contexto, MaterialPageRoute(builder: (BuildContext context){
        if(usuarioEncontrado.papel == 'Médico'){
          return TelaMenu();
        } else {
          return TelaMenuEstudante();
        }
      }));
    }

  }

  _configurarBotaoCadastrar(BuildContext contexto) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Cadastrar"),
      onPressed: () {
        _navegarParaTelaCadastro(Usuario('', '', ''), 'Adicionar usuário', contexto);
      },
    );
  }

  void _navegarParaTelaCadastro(Usuario usuario, String titulo, BuildContext contexto) async {
    await Navigator.push(contexto, MaterialPageRoute(builder: (context) {
      return TelaCadastroUsuario(usuario, titulo);
    }));

  }

}
