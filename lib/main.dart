import 'package:flutter/material.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/visoes/cadastro_usuario.dart';
import 'package:hope/visoes/homepage.dart';
import 'package:hope/visoes/lista_doencas.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/visoes/lista_perguntas.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PGIA7310",
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        //'quiz': (context) => Quiz(),
        'listaDoencas': (context) => ListaDoencas(),
        'listaPerguntas': (context) => ListaPerguntas(),
        'perfilUsuario': (context) => EdicaoUsuario()
      },
    );
  }
}

class EdicaoUsuario extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return EdicaoUsuarioState();
  }

}

class EdicaoUsuarioState extends State<EdicaoUsuario> {

  Usuario _usuario;

  @override
  void initState() {
    super.initState();
    Future<Usuario> usuariof = Login.getUsuarioLogado();
    usuariof.then((value) {
      setState(() {
        _usuario = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var page;
    if (_usuario != null)
      page = CadastroUsuario(_usuario, 'Editar usuário');
    else
      page = HomePage();

    return page;
  }

}
