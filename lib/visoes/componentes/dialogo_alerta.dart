import 'package:flutter/material.dart';

class DialogoAlerta {

  static Future show(
      BuildContext context, {
        @required String titulo,
        @required String mensagem,
      }) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mensagem),
            backgroundColor: Colors.white,
          );
        }
    );
  }

}