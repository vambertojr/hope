import 'package:flutter/material.dart';

class DialogoConfirmacaoExclusao {

  static Future show(
      BuildContext context, {
        @required String mensagem,
        @required Function apagar,
      }) {
    return showDialog<void>(
    context: context,
    //barrierDismissible: false,
    builder: (context) {
      Widget botaoCancelar = ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.teal),
        child: Text("Cancelar"),
        onPressed:  () {
          Navigator.of(context).pop();
        },
      );

      Widget botaoContinuar = ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.teal),
        child: Text("Continuar"),
        onPressed:  () {
          apagar();
        },
      );

       return AlertDialog(
        title: Text('Confirmação'),
        content: Text(mensagem),
        actions: [
          botaoCancelar,
          botaoContinuar,
        ],
      );
    }
    );
  }

  static Future showObject(
      BuildContext context, {
        @required String mensagem,
        @required Function apagar,
        @required Object argumento,
      }) {
    return showDialog<void>(
        context: context,
        //barrierDismissible: false,
        builder: (context) {
          Widget botaoCancelar = ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.teal),
            child: Text("Cancelar"),
            onPressed:  () {
              Navigator.of(context).pop();
            },
          );

          Widget botaoContinuar = ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.teal),
            child: Text("Continuar"),
            onPressed:  () {
              apagar(argumento);
            },
          );

          return AlertDialog(
            title: Text('Confirmação'),
            content: Text(mensagem),
            actions: [
              botaoCancelar,
              botaoContinuar,
            ],
          );
        }
    );
  }

}