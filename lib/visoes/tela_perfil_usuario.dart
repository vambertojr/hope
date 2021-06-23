import 'package:flutter/material.dart';
import 'package:hope/controladores/login_controller.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/visoes/tela_cadastro_usuario.dart';
import 'package:hope/visoes/tela_inicial.dart';

class TelaPerfilUsuario extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return TelaPerfilUsuarioState();
  }

}

class TelaPerfilUsuarioState extends State<TelaPerfilUsuario> {

  Usuario _usuario;

  @override
  void initState() {
    super.initState();
    Future<Usuario> usuariof = LoginController.getUsuarioLogado();
    usuariof.then((value) {
      setState(() {
        _usuario = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var page;
    if (_usuario != null) {
      page = TelaCadastroUsuario(_usuario, 'Editar usuário');
    } else {
      page = TelaInicial();
    }
    return page;
  }

}