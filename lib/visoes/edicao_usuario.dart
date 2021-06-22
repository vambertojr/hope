import 'package:flutter/material.dart';
import 'package:hope/modelos/login.dart';
import 'package:hope/modelos/usuario.dart';
import 'package:hope/visoes/usuario_info.dart';
import 'package:hope/visoes/homepage.dart';

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
    if (_usuario != null) {
      page = UsuarioInfo(_usuario, 'Editar usuário');
    } else {
      page = HomePage();
    }
    return page;
  }

}