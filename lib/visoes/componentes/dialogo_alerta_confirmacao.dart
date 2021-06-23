import 'package:flutter/material.dart';

class DialogoAlertaConfirmacao {

  static Future show(
      BuildContext context, {
        @required String titulo,
        @required String mensagem,
        @required Function confirmar,
      }) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          Widget botaoOk = ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.teal),
            child: Text("Ok"),
            onPressed:  () {
              Navigator.pop(context);
              confirmar();
            },
          );

          return AlertDialog(
            title: Text(titulo),
            content: Text(mensagem),
            backgroundColor: Colors.white,
            actions: [
              botaoOk,
            ],
          );
        }
    );
  }

}