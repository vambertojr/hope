import 'package:flutter/material.dart';
import 'package:hope/modelos/quiz.dart';
import 'package:hope/visoes/lista_quiz.dart';
import 'package:hope/visoes/menu_estudante.dart';

class DialogoTermino {

  static Future show(
    BuildContext contexto, {
    @required int totalAcertos,
    @required int totalQuestoes,
    @required Quiz quiz,
  }) {
    return showDialog<void>(
      context: contexto,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          title: CircleAvatar(
            backgroundColor: Colors.green,
            maxRadius: 35.0,
            child: Icon(
              totalAcertos < 6 ? Icons.warning : Icons.favorite,
              color: Colors.grey.shade900,
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Parabéns',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Você acertou $totalAcertos de $totalQuestoes!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Que tal tentar mais uma vez? Quem sabe você consegue acertar todas na próxima!',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Novo quiz'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListaQuiz()),
                );
              },
            ),
            TextButton(
              child: const Text('Sair'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return MenuEstudante();
                }));

              },
            )
          ],
        );
      },
    );
  }

}
