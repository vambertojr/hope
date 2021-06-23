import 'package:flutter/material.dart';
import 'package:hope/controladores/login_controller.dart';
import 'package:hope/visoes/tela_inicial.dart';

class ComponentesUtil {

  static String papelAdmin = 'Administrador';
  static String papelUsuario = 'Usuário';

  logout(BuildContext contexto) async {
    LoginController loginController = LoginController();
    loginController.registrarLogout();
    await Navigator.push(contexto, MaterialPageRoute(builder: (context) {
      return TelaInicial();
    }));
  }

  Widget appBar(String titulo, BuildContext context){
    return AppBar(
      title: Text(titulo),
      backgroundColor: Colors.teal,
      leading: IconButton(icon: Icon(
        Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context, true);
        }
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            logout(context);
          },
          icon: Icon(Icons.logout),
        )
      ],
    );
  }

  voltarParaUltimaTela(BuildContext context) {
    Navigator.pop(context, true);
  }

  String getPrimeirasLetras(String titulo) {
    if(titulo.length>2) return titulo.substring(0, 2);
    else return titulo.substring(0, 1);
  }

}