import 'package:flutter/material.dart';

class CaixaDialogo extends StatelessWidget {
  final String message;
  final IconData icon;
  final double iconSize;
  final double fontSize;

  CaixaDialogo(
      this.message, {
        this.icon,
        this.iconSize = 64.0,
        this.fontSize = 14.0,
      });

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Visibility(
            child: Icon(
              icon,
              size: iconSize,
              color: Colors.black26,
            ),
            visible: icon != null,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              message,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
