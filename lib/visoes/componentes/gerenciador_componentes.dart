import 'package:flutter/material.dart';
import 'package:hope/controladores/login_controller.dart';
import 'package:hope/visoes/tela_inicial.dart';

class GerenciadorComponentes {

  logout(BuildContext contexto) async {
    LoginController loginController = LoginController();
    loginController.registrarLogout();
    await Navigator.push(contexto, MaterialPageRoute(builder: (context) {
      return TelaInicial();
    }));
  }

  AppBar configurarAppBar(String titulo, BuildContext context){
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

  voltarParaUltimaTela(BuildContext contexto) {
    Navigator.pop(contexto, true);
  }

  void exibirDialogoAlerta(String titulo, String mensagem, BuildContext contexto) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      backgroundColor: Colors.white,
    );
    showDialog(
        context: contexto,
        builder: (_) => alertDialog
    );
  }

  void exibirDialogoAlertaComBotao(String titulo, String mensagem, BuildContext contexto) {
    Widget botaoOk = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.teal),
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(contexto).pop();
      },
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(titulo),
      content: Text(mensagem),
      backgroundColor: Colors.white,
      actions: [
        botaoOk,
      ],
    );

    showDialog(
        context: contexto,
        builder: (_) => alertDialog
    );
  }

  String getPrimeirasLetras(String titulo) {
    if(titulo.length>2) return titulo.substring(0, 2);
    else return titulo.substring(0, 1);
  }

}